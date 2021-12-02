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
        static let ReportView = "ReportViewController"
    }
    
    struct TableViewCellId {
        // ReportFormView
        static let FieldCell = "FieldCell"
        static let DatePickerCell = "DatePickerCell"
        static let CommentCell = "CommentCell"
        
        // ReportView
        static let ReportDataCell = "ReportDataCell"
        static let ReportCommentCell = "ReportCommentCell"
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
    
    struct ModelName {
        // ReportFormView
        static let fields = "Fields"
        static let field = "Field"
        static let date = "DatePicker"
        static let suggestion = "Suggestioins"
        static let comment = "Comment"
        
        // Report
        static let data = "Data"
        static let reportComment = "reportComment"
    }
}
