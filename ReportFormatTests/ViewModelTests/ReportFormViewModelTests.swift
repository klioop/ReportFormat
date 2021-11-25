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

class StudentObject: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
}

protocol RealmServiceProtocol {
    func getStudent(with name: String) -> Single<[StudentObject]>
}

class RealmService: RealmServiceProtocol {
    let localRealm = try! Realm()

    func getStudent(with name: String) -> Single<[StudentObject]> {
        let studentObjects = localRealm.objects(StudentObject.self).filter("name CONTAINS %@", "\(name)")
    
        return .just(studentObjects.toArray())
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
    
    let tapDatePickerViewButton = PublishRelay<Void>()
    
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
            searchStudentFromRealm(for: student)
        )
    }
    
    private func searchStudentFromRealm(for field: FieldViewModel) -> Observable<State> {
        field.text
            .skip(while: { $0.isEmpty })
            .distinctUntilChanged()
            .flatMap { [realmService] (text) in
                realmService.getStudent(with: text)
                    .asObservable()
            }
            .map { students in
                let viewModels = students.map { SuggestionViewModel.student(.init($0)) }
                return .focus(field: student, suggestionViewModels: viewModels)
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


struct StudentSuggestionViewModel: Equatable {
    let name = ""
//    let select: PublishRelay<Void>
    
    init(_ studentObject: StudentObject) {
        
    }
    
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
    }
}

struct SubjectSuggestionViewModel: Equatable {
    let name = ""
    
    static func ==(lhs: SubjectSuggestionViewModel, rhs: SubjectSuggestionViewModel) -> Bool {
        return true
    }
}

struct BookSuggestion {
    let title: String
    
    init(title: String) {
        self.title = title
    }
}
    
enum State: Equatable {
        case initial(fields: [FieldViewModel], button: ButtonViewModel)
        case focusDate(datePickerVM: DatePickerViewModel)
        case focus(field: FieldViewModel, suggestionViewModels: [SuggestionViewModel])
    }

enum SuggestionViewModel: Equatable {
    case student(StudentSuggestionViewModel)
    
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
        let viewModels = realmService.studentStub.students.map { SuggestionViewModel.student(.init($0))}
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.student, suggestionViewModels: viewModels)
            ]
        )
    }
    
    private func makeSUT(realmService: RealmServiceStub = .init()) -> (
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
        
        let sut = ReportFormViewModel(date: date, student: student, subject: subject, book: book, range: range, content: content, button: button, realmService: realmService)
        
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
        
        func getStudent(with name: String) -> Single<[StudentObject]> {
            let studentArr = Array<StudentObject>.init(repeating: StudentObject(), count: 2)
            
            return studentStub.studentName == name ? .just(studentArr) : .just([])
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
}


