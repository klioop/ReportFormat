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
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.fieldCell)
            as! FieldCell
            cell.configure(with: vm)
            return cell
        case let .suggestion(vm):
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            switch vm.type {
            case .book:
                let bookVM = vm as! BookSuggestionViewModel
                cell.textLabel?.numberOfLines = 2
                cell.textLabel?.text = bookVM.book.title
                cell.detailTextLabel?.text = "출판년도: " + bookVM.book.pubdate
            case .subject:
                let subjetVM = vm as! SubjectSuggestionViewModel
                cell.textLabel?.text = subjetVM.name
            case .student:
                let studentVM = vm as! StudentSuggestionViewModel
                cell.textLabel?.text = studentVM.name
            }
            return cell
        case let .datePicker(vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.datePickerCell) as! DatePickerCell
            cell.configure(with: vm)
            return cell
        case let .comment(vm):
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.TableViewCellId.commentCell) as! CommentCell
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let nav = navigationController,
           !nav.isToolbarHidden {
            nav.setToolbarHidden(true, animated: false)
        }
    }
}

// MARK: - private function

extension ReportFormViewController {
    
    private func setupUI() {
        tableView.register(UINib(nibName: "FieldCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.fieldCell)
        tableView.register(UINib(nibName: "DatePickerCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.datePickerCell)
        tableView.register(UINib(nibName: "CommentCell", bundle: nil), forCellReuseIdentifier: Identifier.TableViewCellId.commentCell)
               
        writeButton.setTitleColor(.lightGray, for: .disabled)
        writeButton.layer.cornerRadius = 6
    }
    
    private func binding() {
        dataSource.animationConfiguration = .init(
            insertAnimation: .fade,
            reloadAnimation: .automatic,
            deleteAnimation: .fade
        )
        // sections 는 UI 가 ReportFormViewModel 의 state 변화에 반응하도록 하기 위한 다리 역할
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
        
        viewModel.buttonViewModel.buttonTitle
            .map { [writeButton] (title) in
                writeButton?.setTitle(title, for: .normal)
            }
            .drive()
            .disposed(by: bag)
        
        
    }
    
    private func createSections(with state: Observable<State>) -> Observable<[ReportFormSection]> {
        return state
            .map { state in
                switch state {
                case let .initial(fields: fields, button: _):
                    return [
                        AnimatableSectionModel(
                            model: Constants.ModelName.fields,
                            items: fields.map(CellViewModel.fields)
                        )
                    ]
                case let .focusDate(datePickerVM: dateVM):
                    return [
                        AnimatableSectionModel(
                            model: Constants.ModelName.date,
                            items: [ .datePicker(dateVM) ]
                        )
                    ]
                case let .focus(field: field, suggestionViewModels: suggestions):
                    return [
                        AnimatableSectionModel(
                            model: Constants.ModelName.field,
                            items: [.fields(field)]
                        ),
                        AnimatableSectionModel(
                            model: Constants.ModelName.suggestion,
                            items: suggestions.map(CellViewModel.suggestion)
                        )
                    ]
                case let .focusComment(vm):
                    return [
                        AnimatableSectionModel(
                            model: Constants.ModelName.comment,
                            items: [.comment(vm)]
                        )
                    ]
                }
            }
    }
}
