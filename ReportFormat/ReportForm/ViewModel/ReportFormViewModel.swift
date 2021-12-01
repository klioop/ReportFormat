//
//  ReportFormViewModel.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation
import RxSwift
import RxCocoa

typealias ReportFormViewModelBuilder = () -> ReportFormViewModel

struct ReportFormViewModel{
    let date: FieldViewModel
    let student: FieldViewModel
    let subject: FieldViewModel
    let book: FieldViewModel
    let range: FieldViewModel
    let comment: FieldViewModel
    let button: ButtonViewModel
    let realmService: RealmServiceProtocol
    let bookService: NaverBookAPIProtocol
    let fieldsShouldBeFilled: [FieldViewModel]
    
    let tapButtonFromDatePickerView = PublishRelay<Void>()
    let tapButton = PublishRelay<Void>()
    let select = PublishRelay<Void>()
    let selectedModel = PublishRelay<CellViewModel>()
    
    private let bag = DisposeBag()
    
    init(
        date: FieldViewModel,
        student: FieldViewModel,
        subject: FieldViewModel,
        book: FieldViewModel,
        range: FieldViewModel,
        comment: FieldViewModel,
        button: ButtonViewModel,
        realmService: RealmServiceProtocol,
        bookService: NaverBookAPIProtocol
    ) {
        self.date = date
        self.student = student
        self.subject = subject
        self.book = book
        self.range = range
        self.comment = comment
        self.button = button
        self.realmService = realmService
        self.bookService = bookService
        
        self.fieldsShouldBeFilled = [date, student, comment]
        
        Observable.combineLatest(date.textForEmptyCheck, student.textForEmptyCheck, comment.textForEmptyCheck)
            .map { dateText, studentText, commentText in
                !dateText.isEmpty && !studentText.isEmpty && !commentText.isEmpty
            }
            .bind(to: button.isEnabled)
            .disposed(by: bag)
        
    }
        
    var state: Observable<State> {
        let allFields = [date, student, subject, book, range, comment]
        let datePickerViewModel = DatePickerViewModel(tapButton: tapButton)
        let commentViewModel = CommentViewModel(tapButton: tapButton)
        
        return Observable.merge(
            .just(.initial(fields: allFields, button: button)),
            focusDate(with: datePickerViewModel),
            toInitial(by: tapButton, fields: allFields),
            focus(for: book),
            searchBooksFromNetwork(for: book),
            toInitialbySelection(allFields),
            focusAndGetData(for: subject, with: .subject),
            getSubjectFromRealm(for: subject),
            focusComment(with: commentViewModel)
        )
    }
    
    private func toInitialbySelection(_ fields: [FieldViewModel]) -> Observable<State> {
        return select
            .withLatestFrom(selectedModel) { ($0, $1) }
            .map { [book, subject] (select, model) -> Void in
                if case let .suggestion(vm) = model {
                    switch vm.type {
                    case .book:
                        let bookVM = vm as! BookSuggestionViewModel
                        book.text.accept(bookVM.text)
                        book.isSearch.accept(true)
                    case .subject:
                        let subjectVM = vm as! SubjectSuggestionViewModel
                        subject.text.accept(subjectVM.name)
                    default:
                        break
                    }
                }
            }
            .map { [button] in
                button.isHidden.accept(false)
                return .initial(fields: fields, button: button)
            }
            
    }
    
    private func toInitial(by action: PublishRelay<Void>, fields: [FieldViewModel]) -> Observable<State> {
        action.map { [button] in
            button.isHidden.accept(false)
            return .initial(fields: fields, button: button)
        }
    }
    
    private func focusAndGetData(for field: FieldViewModel, with type: SuggestionType) -> Observable<State> {
        switch type {
        case .student:
            return field.focus
                .withLatestFrom(realmService.getAllStudents().asObservable()) { ($0, $1) }
                .map { [button, select] (_, students) -> State in
                    button.isHidden.accept(true)
                    let viewModels = students.map { StudentSuggestionViewModel.init($0, select: select) }
                    return .focus(field: field, suggestionViewModels: viewModels)
                }
        case .subject:
            return field.focus
                .withLatestFrom(realmService.getAllSubjects().asObservable()) { ($0, $1) }
                .map { [button, select] (_, subjects) -> State in
                    button.isHidden.accept(true)
                    let viewModels = subjects.map { SubjectSuggestionViewModel.init($0, select: select) }
                    return .focus(field: field, suggestionViewModels: viewModels)
                }
        default:
            return .just(.focus(field: field, suggestionViewModels: []))
        }
    }
    
    private func focus(for field: FieldViewModel) -> Observable<State> {
        field.focus.map { [button] in
            button.isHidden.accept(true)
            return .focus(field: field, suggestionViewModels: [])
        }
    }
    
    private func focusComment(with viewModel: CommentViewModel) -> Observable<State> {
        comment.focus
            .map { [button] in
                viewModel.bind(to: comment)
                button.isHidden.accept(true)
                return .focusComment(viewModel)
            }
    }
        
    private func focusDate(with viewModel: DatePickerViewModel) -> Observable<State> {
        date.focus
            .map { [button] in
                viewModel.bind(to: date)
                button.isHidden.accept(true)
                return .focusDate(datePickerVM: viewModel)
            }
    }
    
    private func searchBooksFromNetwork(for field: FieldViewModel) -> Observable<State> {
        field.textForSearch
            .distinctUntilChanged()
            .skip(1)
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .filter{ !$0.isEmpty }
            .flatMap { [bookService] query in
                return bookService.fetchBooks(with: ["query": "\(query)"])
                    .asObservable()
            }
            .map({ books in
                let viewModels = books.map { [select] in BookSuggestionViewModel($0, select: select) }
                return .focus(field: field, suggestionViewModels: viewModels)
            })
    }
 
    private func getStudentFromRealm(for field: FieldViewModel) -> Observable<State> {
        field.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .skip(while: { $0.isEmpty })
            .flatMap { [realmService] (text) -> Observable<[StudentObject]> in
                let students = realmService.getStudent(with: text)
                return students.asObservable()
            }
            .map { students -> State in
                let viewModels = students.map { [select] in
                    StudentSuggestionViewModel.init($0, select: select)
                }
                return .focus(field: field, suggestionViewModels: viewModels)
            }
    }
    
    private func getSubjectFromRealm(for field: FieldViewModel) -> Observable<State> {
        field.text
            .distinctUntilChanged()
            .skip(while: { $0.isEmpty })
            .flatMap { [realmService] (text) in
                realmService.getSubject(with: text)
                    .asObservable()
            }
            .map { subjects in
                let viewModels = subjects.map { [select] in SubjectSuggestionViewModel.init($0, select: select) }
                return .focus(field: field, suggestionViewModels: viewModels)
            }
    }
    
}

// MARK: - Helpers

private extension ReportFormViewModel {
    
    func singnalToButton() {
        let boolsForTextIsEmpty = fieldsShouldBeFilled.filter { !($0.text.value.isEmpty) }
        button.isEnabled.accept(boolsForTextIsEmpty.count == fieldsShouldBeFilled.count)
    }
}
