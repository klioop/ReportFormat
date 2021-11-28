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
    
    var viewModel: ReportFormViewModel!
    
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        binding()
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
                switch vm.type {
                case .book:
                    let bookVM = vm as! BookSuggestionViewModel
                    cell.textLabel?.text = bookVM.text
                case .subject:
                    let subjetVM = vm as! SubjectSuggestionViewModel
                    cell.textLabel?.text = subjetVM.name
                case .student:
                    let studentVM = vm as! StudentSuggestionViewModel
                    cell.textLabel?.text = studentVM.name
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
        let sections = createSections(with: viewModel.state)
        
        sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
    }
    
    private func createSections(with state: Observable<State>) -> Observable<[ReportFormSection]> {
        return state
            .map { state in
                switch state {
                case let .initial(fields: fields, button: _):
                    return [
                        AnimatableSectionModel(
                            model: "Fields",
                            items: fields.map(CellViewModel.fields)
                        )
                    ]
                case let .focusDate(datePickerVM: dateVM):
                    return [
                        AnimatableSectionModel(
                            model: "DatePicker",
                            items: [ .datePicker(dateVM) ]
                        )
                    ]
                case let .focus(field: field, suggestionViewModels: suggestions):
                    return [
                        AnimatableSectionModel(
                            model: "Field",
                            items: [.fields(field)]
                        ),
                        AnimatableSectionModel(
                            model: "Suggestions",
                            items: suggestions.map(CellViewModel.suggestion)
                        )
                    ]
                case let .focusComment(vm):
                    return [
                        AnimatableSectionModel(
                            model: "Comment",
                            items: [.comment(vm)]
                        )
                    ]
                }
            }
    }
}

