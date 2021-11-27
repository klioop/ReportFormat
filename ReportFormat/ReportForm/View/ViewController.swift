//
//  ViewController.swift
//  ReportFormat
//
//  Created by klioop on 2021/11/26.
//

import UIKit
import RxSwift
import Alamofire
import RxRelay

class ViewController: UIViewController {
    
    let temp = BookAPIManager.shared
    let tt = PublishRelay<[BookResponse.Item]>()
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        temp.fetchBooks(with: ["query": "책"])
            .map { [tt] in
                tt.accept($0)
            }
            .subscribe()
            .disposed(by: bag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tt
            .map {
                print($0)
            }
            .subscribe()
            .disposed(by: bag)
    }
}

