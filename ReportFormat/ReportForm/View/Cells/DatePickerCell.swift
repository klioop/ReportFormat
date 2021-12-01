//
//  DatePickerCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit
import RxSwift

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectionButton: UIButton!
    
    private var bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func configure(with viewModel: DatePickerViewModel) {
        selectionButton.rx.tap
            .bind(to: viewModel.tapButton)
            .disposed(by: bag)
        
        datePicker.rx.value
            .bind(to: viewModel.date)
            .disposed(by: bag)
            
    }
    
}

private extension DatePickerCell {
    func setupUI() {
        selectionButton.layer.cornerRadius = 6
        selectionButton.backgroundColor = UIColor(named: ColorName.main)
        selectionButton.setTitleColor(.white, for: .normal)
    }
}
