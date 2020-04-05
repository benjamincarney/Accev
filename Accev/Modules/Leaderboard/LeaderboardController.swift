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
    var dbRef = Firestore.firestore()
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef.collection("users").getDocuments { querySnapshot, err in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
        configureUI()
        configureTableView()
    }

    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegate()
        //tableView.rowHeight = 50
        setConstraints()
    }

    func setTableViewDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    func setConstraints() {

    }

    @objc
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }

    lazy var descriptionLabel: UITextView = {
        let wheelchairLabel = UITextView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        wheelchairLabel.text = """
                        Current Standings
                        """
        wheelchairLabel.textColor = .gray
        wheelchairLabel.font = R.font.latoRegular(size: 20)
        wheelchairLabel.contentOffset = .zero
        return wheelchairLabel
    }()

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

        self.view.addSubview(descriptionLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        let screenSize = UIScreen.main.bounds

        descriptionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: screenSize.width - 20).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: screenSize.height - 150).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
