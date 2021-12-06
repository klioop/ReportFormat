//
//  Constants.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import Foundation

struct Identifier {
    
    struct StoryBoardId {
        static let reportListViewController = "ReportListViewController"
        static let reportForm = "ReportFormViewController"
        static let reportView = "ReportViewController"
    }
    
    struct TableViewCellId {
        // ReportFormView
        static let fieldCell = "FieldCell"
        static let datePickerCell = "DatePickerCell"
        static let commentCell = "CommentCell"
        
        // ReportView
        static let reportDataCell = "ReportDataCell"
        static let reportCommentCell = "ReportCommentCell"
        
        // ReportListView
        static let reportListCell = "ReportListCell"
        static let reportListEmptyCell = "ReportListEmptyCell"
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
