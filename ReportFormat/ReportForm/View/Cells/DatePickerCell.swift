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
        
        viewModel.dateStringFromEditting
            .map { [weak self, datePicker] (dateString) -> Void in
                guard
                    let datePicker = datePicker,
                    let self = self
                else { return }
                datePicker.date = self.createDateFrom(dateString: dateString)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
    }
    
}

private extension DatePickerCell {
    func setupUI() {
        datePicker.locale = Locale(identifier: "ko-kr")
        selectionButton.layer.cornerRadius = 6
        selectionButton.backgroundColor = UIColor(named: ColorName.main)
        selectionButton.setTitleColor(.white, for: .normal)
    }
    
    func createDateFrom(dateString: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        
        return formatter.date(from: dateString) ?? Date()
    }
}
