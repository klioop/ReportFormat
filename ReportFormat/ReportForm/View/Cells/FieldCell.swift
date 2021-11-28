//
//  FieldCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit

class FieldCell: UITableViewCell {

   
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with viewModel: FieldViewModel) {
        titleLabel.text = viewModel.title
    }
    
}
