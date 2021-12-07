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
    private let boolRelayForBarItem = PublishRelay<Bool>()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<ReportListSection>(
        configureCell: configureCell,
        canEditRowAtIndexPath: canEditRowAtIndexPath,
        canMoveRowAtIndexPath: canMoveRowAtIndexPath
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel = viewModelBuilder( 
            // input: (didTapNewReport, reportSelected, indexToDeleteReport)
            (
                newReportButton.rx.tap.asDriver(),
                tableView.rx.modelSelected(ReportListCellViewModelType.self)
                    .map { model in
                        if case let .list(vm) = model {
                            return vm.report
                        }
                        return Report.emptyReport()
                    }
                    .asDriver(onErrorDriveWith: .empty()),
                tableView.rx.itemDeleted
                    .map {
                        $0.row
                    }
                    .asDriver(onErrorDriveWith: .empty())
                
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
        tableView.rx.itemSelected
            .map { [tableView] in
                guard let tableView = tableView else { return }
                tableView.deselectRow(at: $0, animated: true)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
        
        barItemSettingUp()
        

    }
    
    func binding() {
        viewModel.output.title
            .drive(self.rx.title)
            .disposed(by: bag)
        
        viewModel.output.sections
            .drive(self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)

    }
    
    func barItemSettingUp() {
        navigationItem.rightBarButtonItem = createMenuBarItem()
        boolRelayForBarItem
            .asDriver(onErrorDriveWith: .empty())
            .drive(tableView.rx.isEditing)
            .disposed(by: bag)
        boolRelayForBarItem
            .map { [weak self] in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem = self.getBarButton(upon: $0)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
        
    }
    
    func getBarButton(upon boolValue: Bool) -> UIBarButtonItem {
        let completedBarButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        completedBarButton.rx.tap
            .map { [boolRelayForBarItem] in
                boolRelayForBarItem.accept(false)
            }
            .asDriver(onErrorDriveWith: .empty())
            .drive()
            .disposed(by: bag)
        
        let menuBarButton = createMenuBarItem()
        
        return boolValue ? completedBarButton : menuBarButton
    }
    
    func createMenuBarItem() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            menu: createMenus()
        )
    }
    
    func createMenus() -> UIMenu {
        let menu = UIMenu(
            options: .displayInline, children: [
                UIAction(title: "편집", image: UIImage(systemName: "slider.horizontal.3")) { [boolRelayForBarItem] _ in
                    boolRelayForBarItem.accept(true)
                }
            ]
        )
        return menu
    }
        
}

// MARK: - table dataSource related
private extension ReportListViewController {
    
    var configureCell: RxTableViewSectionedReloadDataSource<ReportListSection>.ConfigureCell {
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
    
    var canEditRowAtIndexPath: RxTableViewSectionedReloadDataSource<ReportListSection>.CanEditRowAtIndexPath {
        return { [weak self] _, _ in
            guard
                let self = self,
                let tableView = self.tableView else { return false }
            return tableView.isEditing ? true : false
        }
    }
    
    var canMoveRowAtIndexPath: RxTableViewSectionedReloadDataSource<ReportListSection>.CanMoveRowAtIndexPath {
        return { _, _ in
            return false
        }
    }
}
