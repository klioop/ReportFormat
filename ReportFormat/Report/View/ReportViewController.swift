//
//  ReportViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit
import RxSwift
import RxDataSources

class ReportViewController: UIViewController, StoryBoarded {
    
    typealias ReportSection = SectionModel<String, ReportCellModelCase>
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    private var viewModel: ReportViewModelProtocol!
    var viewModelBuilder: ReportViewModelProtocol.ViewBuilder!
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = viewModelBuilder((
            createButton.rx.tap.asDriver(),
            createButton.rx.tap.asDriver()
        ))
        binding()
    }
    
}

private extension ReportViewController {
    
    func setupUI() {
        

    }
    
    func binding() {
        viewModel.output
            .title
            .drive(self.rx.title)
            .disposed(by: bag)
    }
    
    func createBarButton(with sfSymbol: String, title: String) -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(UIImage(systemName: sfSymbol), for: .normal)
        button.setTitle(title, for: .normal)
        
        return UIBarButtonItem(customView: button)
    }
}
