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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var createButton: UIButton!
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ReportItemSection> { (dataSource, tableView, IndexPath, item) -> UITableViewCell in
        switch item {
        case let .data(vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.reportDataCell) as! ReportDataCell
            cell.configure(with: vm)
            return cell
        case let .comment(vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.reportCommentCell) as! ReportCommentCell
            cell.configure(with: vm)
            return cell
        }
    }
    private var viewModel: ReportViewModelProtocol!
    var viewModelBuilder: ReportViewModelProtocol.ViewBuilder!
    
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        let rightBarButton = navigationItem.rightBarButtonItem!.customView as! UIButton
        viewModel = viewModelBuilder((
            createButton.rx.tap.asDriver(),
            rightBarButton.rx.tap.asDriver()
        ))
        binding()
    }
    
}
// MARK: - helpers

private extension ReportViewController {
    
    func setupUI() {
        self.tableView.register(UINib(nibName: "ReportCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.reportDataCell)
        self.tableView.register(UINib(nibName: Identifier.TableViewCellId.reportCommentCell, bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.reportCommentCell)
        self.navigationItem.rightBarButtonItem = createBarButton(with: "", title: "수정")
    }
    
    func binding() {
        viewModel.output
            .title
            .drive(self.rx.title)
            .disposed(by: bag)
        
        viewModel.output
            .sections
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.output
            .reportSceneType
            .map { (type) -> Bool in
                switch type {
                case .new:
                    return false
                case .editing:
                    return true
                }
            }
            .map { [weak self] (bool) -> Bool in
                self?.navigationItem.rightBarButtonItem?.customView?.isHidden = bool ? false : true
                return bool
            }
            .drive(self.createButton.rx.isHidden)
            .disposed(by: bag)
    }
    
    func createBarButton(with sfSymbol: String, title: String) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: sfSymbol), for: .normal)
        button.setTitle(title, for: .normal)
        
        return UIBarButtonItem(customView: button)
    }
}
