//
//  ReportFormViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

enum CellViewModel: IdentifiableType {
    case fields(FieldViewModel)
    case datePicker(DatePickerViewModel)
    case suggestion(SuggestionViewModelProtocol)
    case comment(CommentViewModel)
    
    var identity: String {
        switch self {
        case let .fields(vm): return vm.identity
        case let .datePicker(vm): return vm.identity
        case let .suggestion(vm): return vm.identity
        case let .comment(vm): return vm.identity
        }
    }
}

extension CellViewModel: Equatable {
    static func ==(lhs: CellViewModel, rhs: CellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}

class ReportFormViewController: UIViewController, StoryBoarded {
    
    typealias ReportFormSection = AnimatableSectionModel<String, CellViewModel>
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        tableView.register(UINib(nibName: "FieldCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.FieldCell)
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.DatePickerCell)
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.CommentCell)
        
    }
    
    private func binding() {
        let dataSource = RxTableViewSectionedAnimatedDataSource<ReportFormSection> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
            switch item {
            case let .fields(vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.FieldCell)
                as! FieldCell
                cell.configure(with: vm)
                return cell
            case let .suggestion(vm):
                let cell = UITableViewCell()
                if let studentVM = vm as? StudentSuggestionViewModel {
                    cell.textLabel?.text = studentVM.name
                } else if let subjectVM = vm as? SubjectSuggestionViewModel {
                    cell.textLabel?.text = subjectVM.name
                } else if let bookVM = vm as? BookSuggestionViewModel {
                    cell.textLabel?.text = bookVM.text
                }
                return cell
            case let .datePicker(vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.DatePickerCell) as! DatePickerCell
                cell.configure(with: vm)
                return cell
            case let .comment(vm):
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.CommentCell) as! CommentCell
                cell.configure(with: vm)
                return cell
            }
        }
    }
}

