//
//  FieldCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa

class FieldCell: UITableViewCell {

   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    let focusButton: UIButton = {
       let button = UIButton()
        
        return button
    }()
    var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(focusButton)
        focusButton.addTarget(self, action: #selector(focusAction), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        focusButton.frame = inputTextField.frame
        focusButton.layer.borderColor = UIColor.red.cgColor
        focusButton.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func configure(with viewModel: FieldViewModel) -> Void {
        titleLabel.text = viewModel.title
        
        
        viewModel.text
            .bind(to: inputTextField.rx.text)
            .disposed(by: bag)
        
        let textFieldText =  inputTextField.rx.text
            .orEmpty
            .share(replay: 1, scope: .forever)
        
        textFieldText
            .bind(to: viewModel.textForEmptyCheck)
            .disposed(by: bag)
        
        textFieldText
            .map { [viewModel] text -> Void in
                if viewModel.title == "책" && !viewModel.isSearch.value {
                    viewModel.textForSearch.accept(text)
                    return
                }
                viewModel.text.accept(text)
                return
            }
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: bag)
        
        focusButton.rx.tap
            .map { [viewModel] in
                viewModel.isSearch.accept(false)
            }
            .bind(to: viewModel.focus)
            .disposed(by: bag)
    }
    
    @objc
    func focusAction() {
        inputTextField.becomeFirstResponder()
    }
    
}
