//
//  MenuTableViewCell.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 07/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import Foundation

class MenuTableViewCell: UITableViewCell {
    
    lazy var option: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    lazy var selectedIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "selected")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: MenuTableViewCell.className)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(option)
        addSubview(selectedIcon)
        option.anchor(top: topAnchor, bottom: bottomAnchor)
        selectedIcon.anchorCenterYToSuperview()
        selectedIcon.anchor(left: option.rightAnchor, right: rightAnchor, leftConstant: 8, widthConstant: 15, heightConstant: 15)
    }
    
    func setupMenuCell(title: String, menu: Menu) {
        option.text = title
        selectedIcon.tintColor = menu.rawValue == title ? #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1) : .gray
    }
}
