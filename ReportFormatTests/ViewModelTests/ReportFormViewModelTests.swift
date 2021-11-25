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
    func getStudent(with name: String) -> Single<StudentObject?>
}

class RealmService: RealmServiceProtocol {
    let localRealm = try! Realm()

    func getStudent(with name: String) -> Single<StudentObject?> {
        let studentObject = localRealm.objects(StudentObject.self).filter("name CONTAINS %@", "\(name)").first
        return .just(studentObject)
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
    
    var state: Observable<State> {
        let allFields = [date, student, subject, book, range, content]
        let datePickerViewModel = DatePickerViewModel()
        
        return Observable.merge(
            .just(.initial(fields: allFields, button: button)),
            date.focus.map { .focusDate(field: date, datePickerVM: datePickerViewModel) },
            student.focus.map { .focus(field: student, suggestionViewModels: [])}
        )
    }
    
}

struct FieldViewModel: Equatable {
    let focus = PublishRelay<Void>()
    
    static func ==(lhs: FieldViewModel, rhs: FieldViewModel) -> Bool {
        return true
    }
}

struct ButtonViewModel: Equatable {
    
}

struct DatePickerViewModel: Equatable {
    
}


struct StudentSuggestionViewModel: Equatable {
    let name = ""
//    let select: PublishRelay<Void>
    
//    init(name: String) {
//
//    }
    
    static func ==(lhs: StudentSuggestionViewModel, rhs: StudentSuggestionViewModel) -> Bool {
        true
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
        case focusDate(field: FieldViewModel, datePickerVM: DatePickerViewModel)
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
    
    func test_focusDate_changeState_includePickerAndPickerButton() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.date.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focusDate(field: fileds.date, datePickerVM: DatePickerViewModel())
            ]
        )
    }
    
    func test_focusFields_changeState_includeOneField() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.date.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focusDate(field: fileds.date, datePickerVM: DatePickerViewModel())
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
    

    
}


private func makeSUT() -> (
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
    
    let sut = ReportFormViewModel(date: date, student: student, subject: subject, book: book, range: range, content: content, button: button)
    
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

class RealmServiceStub: RealmService {
    let stub = (name: "abc", student: StudentObject())
    
    override func getStudent(with name: String) -> Single<StudentObject?> {
        stub.name == name ? .just(stub.student) : .just(nil)
    }
        
}
