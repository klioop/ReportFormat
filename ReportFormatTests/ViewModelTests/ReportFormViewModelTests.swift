//
//  ReportFormViewModelTests.swift
//  ReportFormatTests
//
//  Created by klioop on 2021/11/25.
//

import XCTest
import RxSwift


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
            .just(.initial(fields: allFields, button: button))
        )
    }
    
}

struct FieldViewModel: Equatable {
    
}

struct ButtonViewModel: Equatable {
    
}

class ReportFormViewModelTests: XCTestCase {
            
    func test_initialState_includeAllFieldsAndButton() {
        let (sut, fileds, button) = makeSUT()
        let state = StateSpy(sut.state)
        
        XCTAssertEqual(state.values, [.initial(fields: fileds.all, button: button)])
    }
    
}

enum State: Equatable {
    case initial(fields: [FieldViewModel], button: ButtonViewModel)
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
