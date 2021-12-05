//
//  ReportCommentCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit

class ReportCommentCell: UITableViewCell {

    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

   
    
}

extension ReportCommentCell {
    func configure(with viewModel: ReportCellViewModel) {
        commentTextView.text = viewModel.comment
    }
}

