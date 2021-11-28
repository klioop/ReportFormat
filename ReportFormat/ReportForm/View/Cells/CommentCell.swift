//
//  CommentCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with viewModel: CommentViewModel) {
        
    }

    
    
}
