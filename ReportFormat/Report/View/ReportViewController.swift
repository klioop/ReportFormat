//
//  ReportViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/02.
//

import UIKit
import RxSwift

class ReportViewController: UIViewController, StoryBoarded {
    
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
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.uturn.left"), for: .normal)
        button.setTitle("수정", for: .normal)
        let leftBarButton = UIBarButtonItem(customView: button)
//        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func binding() {
        viewModel.output
            .title
            .drive(self.rx.title)
            .disposed(by: bag)
    }
}
