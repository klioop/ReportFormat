//
//  ReportCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit

class ReportDataCell: UITableViewCell {

    @IBOutlet weak var bookImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension ReportDataCell {
    func configure(with viewModel: ReportCellViewModel) {
        
    }
}
