//
//  ViewController.swift
//  ReactorKitTestPractice
//
//  Created by 앱지 Appg on 2022/09/30.
//

import UIKit
import SafariServices
import ReactorKit
import RxCocoa
import RxSwift

class ViewController: UIViewController, StoryboardView {
    
    var disposeBag = DisposeBag()
    
    @IBOutlet var tableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.scrollIndicatorInsets.top = tableView.contentInset.top
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.setAnimationsEnabled(false)
        searchController.isActive = true
        searchController.isActive = false
        UIView.setAnimationsEnabled(true)
    }

    func bind(reactor: ViewReactor) {
        // Action
        searchController.searchBar.rx.text
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Reactor.Action.updateQuery($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset
            .withUnretained(self)
            .filter { vc, offset in
                guard vc.tableView.frame.height > 0 else { return false }
                return offset.y + vc.tableView.frame.height >= vc.tableView.contentSize.height - 100
            }
            .map { _ in Reactor.Action.loadNextPage }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.repos }
            .bind(to: tableView.rx.items(cellIdentifier: "cell")) { indexPath, repo, cell in
                cell.textLabel?.text = repo
            }
            .disposed(by: disposeBag)
        
        // View
        tableView.rx.itemSelected
            .subscribe(with: self) { vc, indexPath in
                vc.view.endEditing(true)
                vc.tableView.deselectRow(at: indexPath, animated: false)
                let repo = reactor.currentState.repos[indexPath.row]
                guard let url = URL(string: "https://github.com/\(repo)") else { return }
                let sfVC = SFSafariViewController(url: url)
                vc.searchController.present(sfVC, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
}

