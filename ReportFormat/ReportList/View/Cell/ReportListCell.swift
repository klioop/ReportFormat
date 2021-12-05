//
//  ReportListCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import UIKit

class ReportListCell: UITableViewCell {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configure(with viewModel: ReportListCellViewModel) {
        nameLabel.text = viewModel.report.studentName
        subjectLabel.text = viewModel.report.subject
        dateLabel.text = viewModel.report.reportDate
    }
}

