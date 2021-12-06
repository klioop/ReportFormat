//
//  ReportListViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/12/05.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ReportListViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newReportButton: UIBarButtonItem!
    
    private var viewModel: ReportListViewModelProtocol!
    var viewModelBuilder: ReportListViewModelProtocol.ViewModelBuilder!
    
    private var bag = DisposeBag()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ReportListSection>(configureCell: configureCell)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = viewModelBuilder(
            (
                newReportButton.rx.tap.asDriver(),
                ()
            )
        )
        binding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navCon = navigationController,
           navCon.isToolbarHidden {
            navCon.setToolbarHidden(false, animated: true)
        }
    }
    
}

private extension ReportListViewController {
    func setupUI() {
        tableView.register(UINib(nibName: Identifier.TableViewCellId.reportListCell, bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.reportListCell)
        tableView.register(UINib(nibName: Identifier.TableViewCellId.reportListEmptyCell, bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.reportListEmptyCell)

    }
    
    func binding() {
        viewModel.output.sections
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
            
        
            
    }
        
}

private extension ReportListViewController {
    
    private var configureCell: RxTableViewSectionedReloadDataSource<ReportListSection>.ConfigureCell {
        return { (_, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case .empty:
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.reportListEmptyCell) as! ReportListEmptyCell
                return cell
            case let .list(vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.reportListCell) as! ReportListCell
                cell.configure(with: vm)
                return cell
            }
        }
    }
    
}
