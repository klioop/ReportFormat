//
//  ReportFormViewModelTests.swift
//  ReportFormatTests
//
//  Created by klioop on 2021/11/25.
//

import XCTest


struct ReportFormViewModel {
    let date: FieldViewModel
    let student: FieldViewModel
    let subject: FieldViewModel
    let book: FieldViewModel
    let range: FieldViewModel
    let content: FieldViewModel
    let button: ButtonViewModel
    
}

struct FieldViewModel {
    
}

struct ButtonViewModel {
    
}

class ReportFormViewModelTests: XCTestCase {
            
    func test_initialState_includeAllFieldsAndButton() {
        
        
    }
    
}

enum State {
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
