//
//  ViewController.swift
//  mvvm-101
//
//  Created by FunnyDev on 24/5/2564 BE.
//

import UIKit
import Combine

class UserViewController: UITableViewController {

    var viewModel: UserViewModel!
    var users: [User] = []
    private let apiManager = APIManager()
    private var subscribers: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        fetchUsers()
        observeViewModel()
        // Do any additional setup after loading the view.
    }
    
    private func setupViewModel(){
        viewModel = UserViewModel(apiManager: apiManager, endpoint: .users)
    }
    
    private func fetchUsers(){
        viewModel.fetchUsers()
    }
    
    private func observeViewModel() {
        subscribers = viewModel.usersSubject.sink(receiveCompletion: { (resultCompletion) in
            switch resultCompletion {
            case .failure(let error):
                print(error.localizedDescription)
            default: break
            }
        }) { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let user = users[indexPath.item]
        cell.textLabel?.text = user.name
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }


}

