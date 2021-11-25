//
//  ReportFormViewModelTests.swift
//  ReportFormatTests
//
//  Created by klioop on 2021/11/25.
//

import XCTest
import RxSwift
import RxRelay


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
        
        return Observable.merge(
            .just(.initial(fields: allFields, button: button)),
            date.focus.map { .focus(field: date, datePickerVM: DatePickerViewModel()) }
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

class ReportFormViewModelTests: XCTestCase {
            
    func test_initialState_includeAllFieldsAndButton() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        XCTAssertEqual(state.values, [.initial(fields: fileds.all, button: button)])
    }
    
    func test_focusDate_includePickerAndPickerButton() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        fileds.date.focus.accept(())
        
        XCTAssertEqual(
            state.values, [
                .initial(fields: fileds.all, button: button),
                .focus(field: fileds.date, datePickerVM: DatePickerViewModel())
            ]
        )
    }
    
}

enum State: Equatable {
    case initial(fields: [FieldViewModel], button: ButtonViewModel)
    case focus(field: FieldViewModel, datePickerVM: DatePickerViewModel)
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
