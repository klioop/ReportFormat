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

class ReportFormViewController: UIViewController, StoryBoarded {
    
    typealias ReportFormSection = AnimatableSectionModel<String, CellViewModel>
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var writeButton: UIButton!
    
    private var viewModel: ReportFormViewModel!
    
    var viewModelBuilder: ReportFormViewModelBuilder!
    
    private let bag = DisposeBag()
    
    // MARK: - dataSource
    
    private lazy var dataSource = RxTableViewSectionedAnimatedDataSource<ReportFormSection> { (dataSource, tableView, indexPath, item) -> UITableViewCell in
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
                cell.textLabel?.text = bookVM.title
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = viewModelBuilder()
        binding()
        setupUI()
    }
    
    private func setupUI() {
        tableView.register(UINib(nibName: "FieldCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.FieldCell)
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.DatePickerCell)
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.CommentCell)
        tableView.rx
            .setDelegate(self)
            .disposed(by: bag)
               
        writeButton.setTitleColor(.lightGray, for: .disabled)
        writeButton.layer.cornerRadius = 6
    }
    
    private func binding() {
        dataSource.animationConfiguration = .init(
            insertAnimation: .fade,
            reloadAnimation: .automatic,
            deleteAnimation: .fade
        )
        // sections 는 UI 가 ReportFormViewModel 의 상태 변화에 반응하도록 하기 위한 다리 역할
        let sections = createSections(with: viewModel.state)
        
        // Output
        sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: bag)
        
        viewModel.buttonViewModel.isEnabled
            .map { [writeButton] in
                guard let button = writeButton else { return }
                button.isEnabled = $0
                button.backgroundColor = button.isEnabled ? UIColor(named: ColorName.main) : .gray
            }
            .asDriver(onErrorJustReturn: ())
            .drive()
            .disposed(by: bag)
        
        viewModel.buttonViewModel.isHidden
            .bind(to: writeButton.rx.isHidden)
            .disposed(by: bag)
        
        // Input
        tableView.rx
            .modelSelected(CellViewModel.self)
            .bind(to: viewModel.selectedModel)
            .disposed(by: bag)
        
        tableView.rx
            .modelSelected(CellViewModel.self)
            .subscribe(onNext: { [weak self] model in
                if case let .suggestion(vm) = model {
                    self?.view.endEditing(true)
                    vm.select.accept(())
                }
            })
            .disposed(by: bag)
        
        writeButton.rx.tap
            .bind(to: viewModel.tapWriteButton)
            .disposed(by: bag)
    }
}

// MARK: - private function

extension ReportFormViewController {
    
    private func createSections(with state: Observable<State>) -> Observable<[ReportFormSection]> {
        return state
            .map { state in
                switch state {
                case let .initial(fields: fields, button: _):
                    return [
                        AnimatableSectionModel(
                            model: Constants.Header.fields,
                            items: fields.map(CellViewModel.fields)
                        )
                    ]
                case let .focusDate(datePickerVM: dateVM):
                    return [
                        AnimatableSectionModel(
                            model: Constants.Header.date,
                            items: [ .datePicker(dateVM) ]
                        )
                    ]
                case let .focus(field: field, suggestionViewModels: suggestions):
                    return [
                        AnimatableSectionModel(
                            model: Constants.Header.field,
                            items: [.fields(field)]
                        ),
                        AnimatableSectionModel(
                            model: Constants.Header.suggestion,
                            items: suggestions.map(CellViewModel.suggestion)
                        )
                    ]
                case let .focusComment(vm):
                    return [
                        AnimatableSectionModel(
                            model: Constants.Header.comment,
                            items: [.comment(vm)]
                        )
                    ]
                }
            }
    }
}

// MARK: - tableView delegate

extension ReportFormViewController: UITableViewDelegate {
    

}

