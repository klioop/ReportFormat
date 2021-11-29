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
    
    let tapButton = PublishRelay<Void>()
    let tapReturn = PublishRelay<Void>()
    let select = PublishRelay<Void>()
    
    var state: Observable<State> {
        let allFields = [date, student, subject, book, range, comment]
        let datePickerViewModel = DatePickerViewModel(tapButton: tapButton)
        let commentViewModel = CommentViewModel(tapButton: tapButton)
        
        return Observable.merge(
            .just(.initial(fields: allFields, button: button)),
            focusDate(with: datePickerViewModel),
            toInitial(by: tapButton, fields: allFields),
            focus(for: student),
            focus(for: subject),
            focus(for: book),
            getStudentFromRealm(for: student),
            toInitial(by: tapReturn, fields: allFields),
            toInitial(by: select, fields: allFields),
            getSubjectFromRealm(for: subject),
            searchBooksFromNetwork(for: book),
            focusComment(with: commentViewModel)
        )
    }
    
    private func toInitial(by action: PublishRelay<Void>, fields: [FieldViewModel]) -> Observable<State> {
        action.map { [button] in
            button.isHidden.accept(false)
            return .initial(fields: fields, button: button)
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
                button.isHidden.accept(false)
                return .focusComment(viewModel)
            }
    }
        
    private func focusDate(with viewModel: DatePickerViewModel) -> Observable<State> {
        date.focus.map { [button] in
            button.isHidden.accept(true)
            return .focusDate(datePickerVM: viewModel)
        }
    }
    
    private func searchBooksFromNetwork(for field: FieldViewModel) -> Observable<State> {
        field.text
            .distinctUntilChanged()
            .skip(while: { $0.isEmpty })
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
        let students = field.text
            .debounce(.milliseconds(300), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .skip(while: { $0.isEmpty })
            .flatMap { [realmService] (text) -> Observable<[StudentObject]> in
                let students = realmService.getStudent(with: text)
                return students.asObservable()
            }
        
        return students
            .withLatestFrom(field.text.asObservable()) { ($0, $1) }
            .map { [realmService] (students, text) -> [StudentObject] in
                if students.isEmpty {
                    do {
                        try realmService.addStudent(with: text)
                    } catch {
                        throw RealmError.failedToAddObject
                    }
                    return []
                } else {
                    return students
                }
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
