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
    let buttonViewModel: ButtonViewModel
    let realmService: RealmServiceProtocol
    let bookService: NaverBookAPIProtocol
    
    let fieldsShouldBeFilled: [FieldViewModel]
    let datePickerViewModel: DatePickerViewModel
    let commentViewModel: CommentViewModel
    
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
        buttonViewModel: ButtonViewModel,
        realmService: RealmServiceProtocol,
        bookService: NaverBookAPIProtocol
    ) {
        self.date = date
        self.student = student
        self.subject = subject
        self.book = book
        self.range = range
        self.comment = comment
        self.buttonViewModel = buttonViewModel
        self.realmService = realmService
        self.bookService = bookService
        self.fieldsShouldBeFilled = [date, student, comment]
        self.datePickerViewModel = DatePickerViewModel(tapButton: tapButton)
        self.commentViewModel = CommentViewModel(tapButton: tapButton)
        
        Observable.combineLatest(date.textForEmptyCheck, student.textForEmptyCheck, comment.textForEmptyCheck)
            .map { dateText, studentText, commentText in
                !dateText.isEmpty && !studentText.isEmpty && !commentText.isEmpty
            }
            .bind(to: buttonViewModel.isEnabled)
            .disposed(by: bag)
        
        datePickerViewModel.bind(to: date)
        commentViewModel.bind(to: comment)
    }
        
    var state: Observable<State> {
        let allFields = [date, student, subject, book, range, comment]
                
        return Observable.merge(
            .just(.initial(fields: allFields, button: buttonViewModel)),
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
}

// MARK: - Helpers

private extension ReportFormViewModel {
    
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
            .map { [buttonViewModel] in
                buttonViewModel.isHidden.accept(false)
                return .initial(fields: fields, button: buttonViewModel)
            }
            
    }
    
    private func toInitial(by action: PublishRelay<Void>, fields: [FieldViewModel]) -> Observable<State> {
        action.map { [buttonViewModel] in
            buttonViewModel.isHidden.accept(false)
            return .initial(fields: fields, button: buttonViewModel)
        }
    }
    
    private func focusAndGetData(for field: FieldViewModel, with type: SuggestionType) -> Observable<State> {
        switch type {
        case .student:
            return field.focus
                .withLatestFrom(realmService.getAllStudents().asObservable()) { ($0, $1) }
                .map { [buttonViewModel, select] (_, students) -> State in
                    buttonViewModel.isHidden.accept(true)
                    let viewModels = students.map { StudentSuggestionViewModel.init($0, select: select) }
                    return .focus(field: field, suggestionViewModels: viewModels)
                }
        case .subject:
            return field.focus
                .withLatestFrom(realmService.getAllSubjects().asObservable()) { ($0, $1) }
                .map { [buttonViewModel, select] (_, subjects) -> State in
                    buttonViewModel.isHidden.accept(true)
                    let viewModels = subjects.map { SubjectSuggestionViewModel.init($0, select: select) }
                    return .focus(field: field, suggestionViewModels: viewModels)
                }
        default:
            return .just(.focus(field: field, suggestionViewModels: []))
        }
    }
    
    private func focus(for field: FieldViewModel) -> Observable<State> {
        field.focus.map { [buttonViewModel] in
            buttonViewModel.isHidden.accept(true)
            return .focus(field: field, suggestionViewModels: [])
        }
    }
    
    private func focusComment(with viewModel: CommentViewModel) -> Observable<State> {
        comment.focus
            .map { [buttonViewModel] in
                buttonViewModel.isHidden.accept(true)
                return .focusComment(viewModel)
            }
    }
        
    private func focusDate(with viewModel: DatePickerViewModel) -> Observable<State> {
        date.focus
            .map { [buttonViewModel] in
                buttonViewModel.isHidden.accept(true)
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
