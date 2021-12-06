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
        
        let commentText = viewModel.commentText
            .share(replay: 1, scope: .whileConnected)
        
        commentText
            .map { [saveButton] in
                let disableFlag = ($0.isEmpty) || ($0 == Constants.commentTextViewPlaceHolder)
                saveButton?.backgroundColor = disableFlag ? .gray : UIColor(named: ColorName.main)
                return !disableFlag
            }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        commentText
            .bind(to: commentTextView.rx.text)
            .disposed(by: bag)
        
        commentTextView.rx.didBeginEditing
            .map { [weak self] in
                guard let textView = self?.commentTextView else { return }
                self?.setPlaceHolder(to: textView, with: viewModel)
            }
            .asDriver(onErrorJustReturn: ())
            .drive()
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
        commentTextView.text = Constants.commentTextViewPlaceHolder
        commentTextView.textColor = .lightGray
    }
    
    func setPlaceHolder(to textView: UITextView, with viewModel: CommentViewModel) {
        let isStart = textView.text == Constants.commentTextViewPlaceHolder
        textView.text = isStart ? "" : viewModel.commentText.value
    }
    
}

extension CommentCell: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        commentTextView.textColor = .label
    }
}
