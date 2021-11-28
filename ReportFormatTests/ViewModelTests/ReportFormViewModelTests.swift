//
//  ReportFormViewModelTests.swift
//  ReportFormatTests
//
//  Created by klioop on 2021/11/25.
//

import XCTest
import RxSwift
import RxRelay
import RealmSwift
@testable import ReportFormat

class ReportFormViewModelTests: XCTestCase {
            
    func test_initialState_includeAllFieldsAndButton() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        XCTAssertEqual(state.values, [.initial(fields: fileds.all, button: button)])
    }
    
    func test_focusDate_changeState_includeDatePickerViewModel() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.date.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focusDate(datePickerVM: DatePickerViewModel())
            ]
        )
    }
    
    func test_selectDate_AndTapButton_changeState() throws {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.date.focus.accept(())
        
        let datePickerVM = try XCTUnwrap(state.values.last?.datePickerViewModel, "Expected State has to return datePickerViewModel")
        datePickerVM.tapButton.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focusDate(datePickerVM: DatePickerViewModel()),
                .initial(fields: fileds.all, button: button)
            ]
        )
    }
        
    func test_focus_studentField_changeState_includeOneField() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.student.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.student, suggestionViewModels: [])
            ]
        )
    }
    
    func test_focus_subject_changeState_includeOneField() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.subject.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.subject, suggestionViewModels: [])
            ]
        )
    }
    
    func test_focus_book_changeState_includeOneField() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.book.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.book, suggestionViewModels: [])
            ]
        )
    }
    
    func test_focus_range_notChangeState() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.range.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
            ]
        )
    }
    
    func test_student_textChangeState_providesStudentSuggestion_basedOnText() {
        let realmService = RealmServiceStub()
        let (sut, fileds, button) = makeSUT(realmService: realmService)
        let state = StateSpy(sut.state)
        
        fileds.student.text.accept(realmService.studentStub.studentName)
        let viewModels = realmService.studentStub.students.map { StudentSuggestionViewModel.init($0) }
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.student, suggestionViewModels: viewModels)
            ]
        )
    }
    
    func test_student_textChangeState_tapReturnOnKeyboardChangeState() {
        let realmService = RealmServiceStub()
        let (sut, fileds, button) = makeSUT(realmService: realmService)
        let state = StateSpy(sut.state)
        
        fileds.student.text.accept(realmService.studentStub.studentName)
        let viewModels = realmService.studentStub.students.map { StudentSuggestionViewModel.init($0)}
        
        sut.tapReturn.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.student, suggestionViewModels: viewModels),
                .initial(fields: fileds.all, button: button)
                    
            ]
        )
    }
    
    func test_student_textChangeState_selectSuggestionChangeState() throws {
        let realmService = RealmServiceStub()
        let (sut, fileds, button) = makeSUT(realmService: realmService)
        let state = StateSpy(sut.state)
        
        fileds.student.text.accept(realmService.studentStub.studentName)
        let viewModels = realmService.studentStub.students.map(StudentSuggestionViewModel.init)
        
        let studentSuggestionVM = try XCTUnwrap(state.values.last?.firstSuggestionViewModel)
        studentSuggestionVM.select.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.student, suggestionViewModels: viewModels),
                .initial(fields: fileds.all, button: button)
            ]
        )
    }
    
    func test_subject_textChangeState_provideSubjectSuggestion_basedOnText() {
        let realmService = RealmServiceStub()
        let (sut, fileds, button) = makeSUT(realmService: realmService)
        let state = StateSpy(sut.state)
        
        fileds.subject.text.accept(realmService.subjectStub.subjectName)
        let viewModels = realmService.subjectStub.subjects.map(SubjectSuggestionViewModel.init)
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.subject, suggestionViewModels: viewModels)
            ]
        )
    }
    
    func test_subject_textChangeState_selectSuggestionChangeState() throws {
        let realmService = RealmServiceStub()
        let (sut, fileds, button) = makeSUT(realmService: realmService)
        let state = StateSpy(sut.state)
        
        fileds.subject.text.accept(realmService.subjectStub.subjectName)
        let viewModels = realmService.subjectStub.subjects.map(SubjectSuggestionViewModel.init)
        
        let studentSuggestionVM = try XCTUnwrap(state.values.last?.firstSuggestionViewModel)
        studentSuggestionVM.select.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.subject, suggestionViewModels: viewModels),
                .initial(fields: fileds.all, button: button)
            ]
        )
    }
    
    func test_book_textChangeState_providesBookSuggestion_basedOnText() {
        let apiService = BookAPIManagerStub()
        let (sut, fields, button) = makeSUT(apiService: apiService)
        let state = StateSpy(sut.state)
        
        fields.book.text.accept(apiService.stub.query)
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fields.all, button: button),
                .focus(
                    field: fields.book,
                    suggestionViewModels: apiService.stub.books.map(BookSuggestionViewModel.init)
                ),
            ]
        )
    }
    
    func test_selectBook_changeStateIntoInitial() throws {
        let apiService = BookAPIManagerStub()
        let (sut, fields, button) = makeSUT(apiService: apiService)
        let state = StateSpy(sut.state)
        
        fields.book.text.accept(apiService.stub.query)
        
        let viewModel = try XCTUnwrap(state.values.last?.firstSuggestionViewModel)
        viewModel.select.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fields.all, button: button),
                .focus(
                    field: fields.book,
                    suggestionViewModels: apiService.stub.books.map(BookSuggestionViewModel.init)
                ),
                .initial(fields: fields.all, button: button)
            ]
        )
    }
    
    func test_focus_commentField_ChangeState() {
        let (sut, fields, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fields.comment.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fields.all, button: button),
                .focusComment(CommentViewModel())
            ]
        )
    }
    
    func test_commentView_tapButton_ChangeStateIntoInitial() throws {
        let (sut, fields, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fields.comment.focus.accept(())
        
        let viewModel = try XCTUnwrap(state.values.last?.commentViewModel)
        viewModel.tapButton.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fields.all, button: button),
                .focusComment(CommentViewModel()),
                .initial(fields: fields.all, button: button)
            ]
        )
    }
    
    private func makeSUT(
        realmService: RealmServiceStub = .init(),
        apiService: BookAPIManagerStub = .init()
    ) -> (
        sut: ReportFormViewModel,
        fields: (
            date: FieldViewModel,
            student: FieldViewModel,
            subject: FieldViewModel,
            book: FieldViewModel,
            range: FieldViewModel,
            comment: FieldViewModel,
            all: [FieldViewModel]
        ),
        button: ButtonViewModel
    ) {
        let date = FieldViewModel()
        let student = FieldViewModel()
        let subject = FieldViewModel()
        let book = FieldViewModel()
        let range = FieldViewModel()
        let comment = FieldViewModel()
        
        let button = ButtonViewModel()
        
        let sut = ReportFormViewModel(date: date, student: student, subject: subject, book: book, range: range, comment: comment, button: button, realmService: realmService, bookService: apiService)
        
        return (
            sut,
            (
                date,
                student,
                subject,
                book,
                range,
                comment,
                [date, student, subject, book, range, comment]
            ),
            button
        )
    }

    class StateSpy {
        private(set) var values: [State] = []
        private let bag = DisposeBag()
        
        init(_ observable: Observable<State>) {
            observable
                .subscribe(onNext: { [weak self] state in
                    self?.values.append(state)
                })
                .disposed(by: bag)
        }
    }

    class RealmServiceStub: RealmServiceProtocol {
        
        lazy var studentStub = (studentName: "abc", students: [StudentObject(), StudentObject()])
        lazy var subjectStub = (subjectName: "math", subjects: [SubjectObject(), SubjectObject()])
        
        func getStudent(with name: String) -> Single<[StudentObject]> {
            return studentStub.studentName == name ? .just(studentStub.students) : .just([])
        }
        
        func getSubject(with name: String) -> Single<[SubjectObject]> {
            return subjectStub.subjectName == name ? .just(subjectStub.subjects) : .just([])
        }
            
    }
    
    class BookAPIManagerStub: NaverBookAPIProtocol {
        
        let stub = (query: "book", books: [Book(), Book()])
        
        func fetchBooks(with query: [String : String]) -> Single<[Book]> {
            let query = query["query"] ?? "?"
            return stub.query == query ? .just(stub.books) : .just([])
        }
        
        
    }

    
}

private extension State {
    var datePickerViewModel: DatePickerViewModel? {
        switch self {
        case let .focusDate(datePickerVM: vm):
            return vm
        default:
            return nil
        }
    }
    
    var firstSuggestionViewModel: SuggestionViewModelProtocol? {
        switch self {
        case let .focus(field: _, suggestionViewModels: viewModels):
            return viewModels.first
        default:
            return nil
        }
    }
    
    var commentViewModel: CommentViewModel? {
        switch self{
        case let .focusComment(vm):
            return vm
        default:
            return nil
        }
    }
}


