//
//  MenuViewController.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

private let reuseIdentifer = "MenuOptionCell"

class MenuController: UIViewController {

    var tableView: UITableView!
    // swiftlint:disable all
    var delegate: HomeControllerDelegate?
    // swiftlint:enable all
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }

    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuOptionCell.self, forCellReuseIdentifier: reuseIdentifer)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = Colors.mostlyOpaqueText
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 115)
        tableView.backgroundColor = Colors.behindGradient
        tableView.rowHeight = 80
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    }
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifer, for: indexPath) as! MenuOptionCell
        let menuOption = MenuOption(rawValue: indexPath.row)
        cell.descriptionLabel.text = menuOption?.description
        cell.iconImageView.image = menuOption?.image
        // cell.selectionStyle = .gray
        cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.4) {
            cell.transform = CGAffineTransform.identity
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuOption = MenuOption(rawValue: indexPath.row)
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
}

//
//class BlurredBackgroundView: UIView {
//    let imageView: UIImageView
//    let blurView: UIVisualEffectView
//
//    override init(frame: CGRect) {
//        let blurEffect = UIBlurEffect(style: .regular)
//        blurView = UIVisualEffectView(effect: blurEffect)
//        imageView = UIImageView(image: UIImage.gorgeousImage())
//        super.init(frame: frame)
//        addSubview(imageView)
//        addSubview(blurView)
//    }
//
//    convenience required init?(coder aDecoder: NSCoder) {
//        self.init(frame: CGRect(x: 0,y: 0,width: 0,height: 0))
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        imageView.frame = bounds
//        blurView.frame = bounds
//    }
//}
//
//extension UIImage {
//    class func gorgeousImage() -> UIImage {
//        return UIImage(named: "otherGradient2")!
//    }
//}
