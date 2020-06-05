//
//  MainView.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 02/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit

protocol AlertDelegate {
    func presentAlert(wod: Card)
}

class MainView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {

    lazy var wodCardCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: buildCollectionViewFlowLayout())
        collection.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        registerCollectionViewCells()
        setupComponents()
        wodCardCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MainViewModel?
    var alertDelegate: AlertDelegate?
    
    func setupComponents() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(wodCardCollectionView)
        wodCardCollectionView.anchor(top: safeAreaLayoutGuide.topAnchor,
                                     left: safeAreaLayoutGuide.leftAnchor,
                                     bottom: safeAreaLayoutGuide.bottomAnchor,
                                     right: safeAreaLayoutGuide.rightAnchor,
                                     topConstant: 15,
                                     leftConstant: 15,
                                     bottomConstant: 10,
                                     rightConstant: 15)
    }
    
    private func registerCollectionViewCells() {
        wodCardCollectionView.register(WodCardCollectionViewCell.self, forCellWithReuseIdentifier: WodCardCollectionViewCell.className)
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.wods?.cards.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WodCardCollectionViewCell.className, for: indexPath) as? WodCardCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.setupCardCell(model: viewModel?.wods?.cards[indexPath.row] ?? Card(title: "Fran", description: "21 - 15 - 9"))
        return cell
    }
}


// MARK: - UICollectionViewFlowLayout
extension MainView: UICollectionViewDelegateFlowLayout {
    func buildCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 10
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / 1.15, height: 150)
    }

}

extension MainView: AddListDelegate {
    func addWodToList(wod: Card) {
        alertDelegate?.presentAlert(wod: wod)
    }
}


extension NSObject {
    /// String describing the class name.
    static var className: String {
        return String(describing: self)
    }
}


