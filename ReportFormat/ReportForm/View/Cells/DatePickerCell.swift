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
    
    private let bag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with viewModel: DatePickerViewModel) {
        selectionButton.rx.tap
            .bind(to: viewModel.tapButton)
            .disposed(by: bag)
    }
    
    
}
