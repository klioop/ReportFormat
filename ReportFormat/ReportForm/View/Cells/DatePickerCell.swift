//
//  DatePickerCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit

class DatePickerCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var selectionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with viewModel: DatePickerViewModel) {
        
    }
    
}
