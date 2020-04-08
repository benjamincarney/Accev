//
//  LeaderboardController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/18/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import Firebase
import UIKit

class LeaderboardController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var username: String?
    var tableView = UITableView()
    var leaderBoard = [String]()
    let users = Firestore.firestore().collection("users")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        users.whereField("numPinsAdded", isGreaterThan: 0).order(by: "numPinsAdded", descending: true).getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    print("Please be the email \(document.documentID)")
                    let currentUser: String = document.documentID
                    self.leaderBoard.append(currentUser)
                }
            }
            print(self.leaderBoard)
            self.configureTableView()
            self.tableView.reloadData()
        }
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableView()
        setConstraints()
    }

    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DankCell")
        tableView.backgroundColor = Colors.behindGradient
        tableView.layer.cornerRadius = 5.0
    }

    func setConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        } else {
            // Fallback on earlier versions
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        }
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 160).isActive = true
    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    func configureUI() {
        view.backgroundColor = .white
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).textColor = Colors.behindGradient
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        navigationItem.title = "Leaderboard"
        navigationController?.navigationBar.barStyle = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x24blue").withRenderingMode(.alwaysOriginal),
                                                           style: .plain, target: self,
                                                           action: #selector(handleDismiss))
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row < 3) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DankCell", for: indexPath)
            cell.backgroundColor = Colors.behindGradient
            cell.textLabel?.textColor = UIColor.white
            cell.textLabel?.text = "\(indexPath.row + 1). " + leaderBoard[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}
