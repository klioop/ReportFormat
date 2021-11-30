//
//  CommentCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay

class CommentCell: UITableViewCell {

    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var commentTextView: UITextView!
    
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func configure(with viewModel: CommentViewModel) {
        saveButton.rx.tap
            .bind(to: viewModel.tapButton)
            .disposed(by: bag)
        
        commentTextView.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.commentText)
            .disposed(by: bag)        
    }

    
    
}
