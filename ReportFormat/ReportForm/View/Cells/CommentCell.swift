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
        setupUI()
        commentTextView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func configure(with viewModel: CommentViewModel) {
        saveButton.rx.tap
            .bind(to: viewModel.tapButton)
            .disposed(by: bag)
        
        viewModel.commentText
            .map { [saveButton] in
                let isTextEmpty = $0.isEmpty
                saveButton?.backgroundColor = isTextEmpty ? .gray : UIColor(named: ColorName.main)
                return !isTextEmpty
            }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        commentTextView.rx.text
            .orEmpty
            .asDriver()
            .drive(viewModel.commentText)
            .disposed(by: bag)        
    }
        
}

private extension CommentCell {
    func setupUI() {
        saveButton.isEnabled = false
        saveButton.layer.cornerRadius = 6
        saveButton.setTitleColor(.lightGray, for: .disabled)
        saveButton.setTitleColor(.white, for: .normal)
        commentTextView.text = "여기에 입력해주세요"
        commentTextView.textColor = .lightGray
    }
}

extension CommentCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.text = ""
        commentTextView.textColor = .label
    }
}
