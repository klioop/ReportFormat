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
        setupUI()
    }

   
    
}

extension ReportCommentCell {
    func configure(with viewModel: ReportCellViewModel) {
        commentTextView.text = viewModel.comment
    }
}

private extension ReportCommentCell {
    func setupUI() {
        commentTextView.isEditable = false
        commentTextView.layer.cornerRadius = 6
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor(named: ColorName.secondary)?.cgColor
    }
}
