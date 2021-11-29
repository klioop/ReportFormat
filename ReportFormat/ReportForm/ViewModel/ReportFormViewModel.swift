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
            tapButtonAction(allFields),
            focus(for: student),
            focus(for: subject),
            focus(for: book),
            getStudentFromRealm(for: student),
            tapReturnAction(allFields),
            toInitial(for: select, fields: allFields),
            getSubjectFromRealm(for: subject),
            searchBooksFromNetwork(for: book),
            focusComment(with: commentViewModel)
        )
    }
    
    private func toInitial(for action: PublishRelay<Void>, fields: [FieldViewModel]) -> Observable<State> {
        action.map { [button] in
            button.isHidden.accept(false)
            return .initial(fields: fields, button: button)
        }
    }
    
    private func tapReturnAction(_ fields: [FieldViewModel]) -> Observable<State> {
        tapReturn.map { [button] in
            button.isHidden.accept(false)
            return .initial(fields: fields, button: button)
        }
    }
    
    private func tapButtonAction(_ fields: [FieldViewModel]) -> Observable<State> {
        tapButton.map { [button] in
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
        field.text
            .distinctUntilChanged()
            .skip(while: { $0.isEmpty })
            .flatMap { [realmService] (text) in
                realmService.getStudent(with: text)
                    .asObservable()
            }
            .map { students in
                let viewModels = students.map { [select] in StudentSuggestionViewModel.init($0, select: select) }
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
