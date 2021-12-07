//
//  ReportListEmptyCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import UIKit

class ReportListEmptyCell: UITableViewCell {

    @IBOutlet weak var emptyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
}

private extension ReportListEmptyCell {
    func setupUI() {
        emptyTextLabel.layer.cornerRadius = 6
        emptyTextLabel.layer.masksToBounds = true
        
    }
}
