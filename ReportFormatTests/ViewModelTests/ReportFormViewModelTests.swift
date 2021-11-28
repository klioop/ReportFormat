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

class StudentObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var dateCreated: Date
}

class SubjectObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var dateCreated: Date
}

protocol RealmServiceProtocol {
    func getStudent(with name: String) -> Single<[StudentObject]>
    func getSubject(with name: String) -> Single<[SubjectObject]>
}

class RealmService: RealmServiceProtocol {
    let localRealm = try! Realm()

    func getStudent(with name: String) -> Single<[StudentObject]> {
        let studentObjects = localRealm.objects(StudentObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(studentObjects.toArray())
    }
    
    func getSubject(with name: String) -> Single<[SubjectObject]> {
        let subjectObjects = localRealm.objects(SubjectObject.self).filter("name CONTAINS %@", "\(name)")
        return .just(subjectObjects.toArray())
    }
    
}

extension Results {
    func toArray() -> Array<Self.Element> {
        self.map { $0 }
    }
        
}

struct ReportFormViewModel {
    let date: FieldViewModel
    let student: FieldViewModel
    let subject: FieldViewModel
    let book: FieldViewModel
    let range: FieldViewModel
    let content: FieldViewModel
    let button: ButtonViewModel
    let realmService: RealmServiceProtocol
    let bookService: NaverBookAPIProtocol
    
    let tapDatePickerViewButton = PublishRelay<Void>()
    let tapReturn = PublishRelay<Void>()
    let select = PublishRelay<Void>()
    
    var state: Observable<State> {
        let allFields = [date, student, subject, book, range, content]
        let datePickerViewModel = DatePickerViewModel(tapButton: tapDatePickerViewButton)
        
        return Observable.merge(
            .just(.initial(fields: allFields, button: button)),
            date.focus.map { .focusDate(datePickerVM: datePickerViewModel) },
            tapDatePickerViewButton.map {.initial(fields: allFields, button: button) },
            student.focus.map { .focus(field: student, suggestionViewModels: [])},
            subject.focus.map { .focus(field: subject, suggestionViewModels: [])},
            book.focus.map { .focus(field: book, suggestionViewModels: [])},
            getStudentFromRealm(for: student),
            tapReturn.map { .initial(fields: allFields, button: button) },
            select.map { .initial(fields: allFields, button: button) },
            getSubjectFromRealm(for: subject),
            searchBooksFromNetwork(for: book)
        )
    }
    
    private func searchBooksFromNetwork(for field: FieldViewModel) -> Observable<State> {
        field.text
            .skip(while: { $0.isEmpty })
            .distinctUntilChanged()
            .flatMap { [bookService] query in
                bookService.fetchBooks(with: ["query": "book"])
                    .asObservable()
            }
            .map({ books in
                let viewModels = books.map { [select] in BookSuggestionViewModel($0, select: select) }
                return .focus(field: field, suggestionViewModels: viewModels)
            })
    }
 
    private func getStudentFromRealm(for field: FieldViewModel) -> Observable<State> {
        field.text
            .skip(while: { $0.isEmpty })
            .distinctUntilChanged()
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
            .skip(while: { $0.isEmpty })
            .distinctUntilChanged()
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

struct FieldViewModel: Equatable {
    let title: String = ""
    
    let text = PublishRelay<String>()
    let focus = PublishRelay<Void>()
    
    static func ==(lhs: FieldViewModel, rhs: FieldViewModel) -> Bool {
        return true
    }
}

struct ButtonViewModel: Equatable {
    
}

struct DatePickerViewModel: Equatable {
    let dateString: PublishRelay<String> = PublishRelay()
    let date = BehaviorRelay<Date>(value: Date())
    let tapButton: PublishRelay<Void>
    
    init(tapButton: PublishRelay<Void>) {
        self.tapButton = tapButton
    }
    
    init() {
        self.tapButton = PublishRelay<Void>()
    }
    
    static func == (lhs: DatePickerViewModel, rhs: DatePickerViewModel) -> Bool {
        true
    }
    
    
}


struct StudentSuggestionViewModel: Equatable, SuggestionViewModelProtocol {
    let name: String
    let select: PublishRelay<Void>
    
    init(_ studentObject: StudentObject, select: PublishRelay<Void>) {
        self.name = studentObject.name
        self.select = select
    }
    
    init(_ studentObject: StudentObject) {
        self.name = studentObject.name
        self.select = PublishRelay<Void>()
    }
        
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
    }
}

struct SubjectSuggestionViewModel: Equatable, SuggestionViewModelProtocol {
    let name: String
    let select: PublishRelay<Void>
    
    init(_ subjectObject: SubjectObject, select: PublishRelay<Void>) {
        self.name = subjectObject.name
        self.select = select
    }
    
    init(_ subjectObject: SubjectObject) {
        self.name = subjectObject.name
        self.select = PublishRelay<Void>()
    }
    
    static func ==(lhs: SubjectSuggestionViewModel, rhs: SubjectSuggestionViewModel) -> Bool {
        return true
    }
}

enum State: Equatable {
    case initial(fields: [FieldViewModel], button: ButtonViewModel)
    case focusDate(datePickerVM: DatePickerViewModel)
    case focus(field: FieldViewModel, suggestionViewModels: [SuggestionViewModelProtocol])
    
    static func == (lhs: State, rhs: State) -> Bool{
        return true
    }
}


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
        
        let studentSuggestionVM = try XCTUnwrap(state.values.last?.firstRealmSuggestionViewModel)
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
        
        let studentSuggestionVM = try XCTUnwrap(state.values.last?.firstRealmSuggestionViewModel)
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
            content: FieldViewModel,
            all: [FieldViewModel]
        ),
        button: ButtonViewModel
    ) {
        let date = FieldViewModel()
        let student = FieldViewModel()
        let subject = FieldViewModel()
        let book = FieldViewModel()
        let range = FieldViewModel()
        let content = FieldViewModel()
        
        let button = ButtonViewModel()
        
        let sut = ReportFormViewModel(date: date, student: student, subject: subject, book: book, range: range, content: content, button: button, realmService: realmService, bookService: apiService)
        
        return (
            sut,
            (
                date,
                student,
                subject,
                book,
                range,
                content,
                [date, student, subject, book, range, content]
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
        
        let localRealm = try! Realm()
                        
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
    
    var firstRealmSuggestionViewModel: SuggestionViewModelProtocol? {
        switch self {
        case let .focus(field: _, suggestionViewModels: viewModels):
            return viewModels.first
        default:
            return nil
        }
    }
}


