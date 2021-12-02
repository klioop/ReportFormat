//
//  ReportViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit

class ReportViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    
    private var viewModel: ReportViewModelProtocol!
    var viewModelBuilder: ReportViewModelProtocol.ViewBuilder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
