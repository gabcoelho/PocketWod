//
//  FavoritesCollectionViewCell.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 04/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit

protocol RemoveFavoriteDelegate {
    func removeFavoriteFromList(cell: UICollectionViewCell)
}

class FavoritesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 1
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var score: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Score: "
        label.textColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4470588235, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var scoreTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4470588235, alpha: 1)
        textField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return textField
    }()

    lazy var removeListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cross")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(removeListButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var wodDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        textView.textColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4470588235, alpha: 1)
        textView.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    var delegate: RemoveFavoriteDelegate?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupCardCell(title: String, description: String, score: String? = nil) {
        titleLabel.text = title
        wodDescription.text = description
        scoreTextField.text = score
    }
    
    private func setupView() {
        contentView.addSubview(stackView)
        stackView.anchorTo(superview: contentView)
        setupTopView()
        setupBottomView()
    }
    
    private func setupTopView() {
        let topView = UIView()
        topView.addSubview(titleLabel)
        topView.addSubview(removeListButton)
        stackView.addArrangedSubview(topView)
        topView.anchor(top: stackView.topAnchor, left: stackView.leftAnchor, right: stackView.rightAnchor, heightConstant: 25)
        titleLabel.anchor(left: topView.leftAnchor, leftConstant: 5)
        removeListButton.anchor(right: topView.rightAnchor, rightConstant: 5, widthConstant: 15, heightConstant: 15)
        stackView.addArrangedSubview(wodDescription)
        wodDescription.anchor(left: stackView.leftAnchor, right: stackView.rightAnchor)
    }
        
    private func setupBottomView() {
        let lineView = UIView()
        lineView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        stackView.addArrangedSubview(lineView)
        lineView.anchor(left: stackView.leftAnchor, right: stackView.rightAnchor, heightConstant: 1)

        let bottomView = UIView()
        bottomView.addSubview(score)
        bottomView.addSubview(scoreTextField)
        bottomView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        bottomView.layer.cornerRadius = 10
        bottomView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        stackView.addArrangedSubview(bottomView)
        
        bottomView.anchor(left: stackView.leftAnchor, bottom: stackView.bottomAnchor, right: stackView.rightAnchor, heightConstant: 30)
        score.anchor(top: bottomView.topAnchor, left: bottomView.leftAnchor, bottom: bottomView.bottomAnchor, leftConstant: 5)
        scoreTextField.anchor(top: bottomView.topAnchor, left: score.rightAnchor, bottom: bottomView.bottomAnchor, right: bottomView.rightAnchor, topConstant: 5, bottomConstant: 5, rightConstant: 5, widthConstant: 200)
    }
    
    @objc private func removeListButtonDidReceiveTouchUpInside() {
        delegate?.removeFavoriteFromList(cell: self)
    }

}

