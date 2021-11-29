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
    @IBOutlet weak var textField: UITextField!
    
    let focusButton: UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(focusAction), for: .touchUpInside)
        
        return button
    }()
    let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(focusButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        focusButton.frame = textField.frame
    }
    
    func configure(with viewModel: FieldViewModel) -> Void {
        titleLabel.text = viewModel.title
        
        viewModel.text
            .bind(to: textField.rx.text)
            .disposed(by: bag)
        
        textField.rx.text
            .orEmpty
            .skip(1)
            .bind(to: viewModel.text)
            .disposed(by: bag)
        
        focusButton.rx.tap
            .bind(to: viewModel.focus)
            .disposed(by: bag)
    }
    
    @objc
    func focusAction() {
        textField.becomeFirstResponder()
    }
    
}
