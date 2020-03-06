//
//  MenuOptionCell.swift
//  Accev
//
//  Created by Benjamin Carney on 3/5/20.
//  Copyright © 2020 Accev. All rights reserved.
//

import UIKit

class MenuOptionCell: UITableViewCell {

    // MARK: - Properties

    let iconImageView: UIImageView = {
        let returnImage = UIImageView()
        returnImage.contentMode = .scaleAspectFit
        returnImage.clipsToBounds = true
        return returnImage
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = R.font.latoRegular(size: 25)
        label.text = "Sample text"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // backgroundColor = Colors.behindGradient        
        backgroundColor = .clear
        selectionStyle = .none
        addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 12).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
