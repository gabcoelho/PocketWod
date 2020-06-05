//
//  WodCardCollectionViewCell.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 02/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit

protocol AddListDelegate {
    func addWodToList(wod: Card)
}

class WodCardCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UIComponents
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        return stack
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    lazy var addListButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(addListButtonDidReceiveTouchUpInside), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    lazy var wodDescription: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 10
        textView.textColor = #colorLiteral(red: 1, green: 0.6392156863, blue: 0.4470588235, alpha: 1)
        textView.backgroundColor = #colorLiteral(red: 0.05882352941, green: 0.2980392157, blue: 0.5058823529, alpha: 1)
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 18)
        return textView
    }()
    
    var delegate: AddListDelegate?

    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setupCardCell(model: Card) {
        title.text = model.title
        wodDescription.text = model.description
    }
    
    private func setupView() {
        contentView.addSubview(stackView)
        let topView = UIView()
        topView.addSubview(title)
        topView.addSubview(addListButton)
        stackView.anchorTo(superview: contentView)
        stackView.addArrangedSubview(topView)
        topView.anchor(top: stackView.topAnchor, left: stackView.leftAnchor, right: stackView.rightAnchor, heightConstant: 25)
        title.anchor(left: topView.leftAnchor, leftConstant: 5)
        addListButton.anchor(right: topView.rightAnchor, rightConstant: 5, widthConstant: 22, heightConstant: 22)
        stackView.addArrangedSubview(wodDescription)
        wodDescription.anchor(left: stackView.leftAnchor, right: stackView.rightAnchor)
    }
    
    @objc private func addListButtonDidReceiveTouchUpInside() {
        
        guard let text = self.title.text,
              let wodDescription = self.wodDescription.text else { return }
        delegate?.addWodToList(wod: Card(title: text, description: wodDescription))
    }

}
