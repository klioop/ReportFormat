//
//  Constants.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation

struct Identifier {
    
    struct StoryBoardId {
        static let ReportForm = "ReportFormViewController"
    }
    
    struct TableViewCellId {
        static let FieldCell = "FieldCell"
        static let DatePickerCell = "DatePickerCell"
        static let CommentCell = "CommentCell"
    }
}

struct ColorName {
    static let main = "mainColor"
}

struct Constants {
    static let commentTextViewPlaceHolder = "여기에 입력해주세요"
    
    struct FieldTitle {
        static let book = "책(검색)"
        static let student = "학생 이름*"
        static let subject = "과목"
        static let range = "범위"
        static let comment = "코멘트*"
        static let date = "날짜*"
    }
}
