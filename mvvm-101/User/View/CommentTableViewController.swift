//
//  CommentTableViewController.swift
//  mvvm-101
//
//  Created by FunnyDev on 1/6/2564 BE.
//

import UIKit
import Combine

class CommentTableViewController: UITableViewController {
    var userID: Int = 0
    
    @IBOutlet weak var navItemTitle: UINavigationItem!
    var viewModel: CommentViewModel!
    var comments: [Comment] = []
    
    private let apiManager = APIManager()
    private var subscribers: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navItemTitle.title = "UserID: \(userID)"
        setupViewModel()
        fetchComments()
        observeViewModel()
    }
    
    private func setupViewModel() {
        viewModel = CommentViewModel(apiManager: apiManager, endpoint: .userComment(userID: String(userID)))
    }
    
    private func fetchComments(){
        viewModel.fetchComment()
    }
    
    private func observeViewModel(){
        subscribers = viewModel.commentSubject.sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }, receiveValue: { comments in
            DispatchQueue.main.async {
                self.comments = comments
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        var content = cell.defaultContentConfiguration()
        
        var primaryText = UIFont.boldSystemFont(ofSize: 22)
        var secondaryText = UIFont.preferredFont(forTextStyle: .body)
        content.text = comments[indexPath.item].title

        content.textProperties.font = primaryText
        content.secondaryText = comments[indexPath.item].body
        content.secondaryTextProperties.font = secondaryText

        cell.contentConfiguration = content
        return cell
    }
}
