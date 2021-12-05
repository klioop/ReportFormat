//
//  ReportCell.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit
import Kingfisher

class ReportDataCell: UITableViewCell {

    @IBOutlet weak var bookImageVIew: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subjectLabel: UILabel!
    @IBOutlet weak var rangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}

extension ReportDataCell {
    func configure(with viewModel: ReportCellViewModel) {
        bookImageVIew.kf.setImage(with: URL(string: viewModel.bookImageUrl ?? ""))
        nameLabel.text = viewModel.studentName
        subjectLabel.text = viewModel.subject ?? ""
        rangeLabel.text = viewModel.range ?? ""
    }
}
