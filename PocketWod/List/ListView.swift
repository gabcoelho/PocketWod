//
//  ListView.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 03/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreData

class ListViewModel {
    var wods: [NSManagedObject] = []
}

protocol DeleteWodDelegate {
    func presentAlertDeleteWod(at: IndexPath)
}

class ListView: UIView {
    
    // MARK: - Computed Properties
    lazy var favoritesCollectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: buildCollectionViewFlowLayout())
        collection.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        collection.showsVerticalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    var viewModel = ListViewModel()
    var delegate: DeleteWodDelegate?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupCoreData()
        registerCollectionViewCells()
        setupComponents()
        favoritesCollectionView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Wod>(entityName: "Wod")
        do {
            viewModel.wods = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            debugPrint("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func setupComponents() {
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        addSubview(favoritesCollectionView)
        favoritesCollectionView.anchor(top: safeAreaLayoutGuide.topAnchor,
                                     left: safeAreaLayoutGuide.leftAnchor,
                                     bottom: safeAreaLayoutGuide.bottomAnchor,
                                     right: safeAreaLayoutGuide.rightAnchor,
                                     topConstant: 15,
                                     leftConstant: 15,
                                     bottomConstant: 10,
                                     rightConstant: 15)
    }
    
    private func registerCollectionViewCells() {
        favoritesCollectionView.register(FavoritesCollectionViewCell.self, forCellWithReuseIdentifier: FavoritesCollectionViewCell.className)

    }
}

// MARK: - DataSource & Delegate
extension ListView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoritesCollectionViewCell.className, for: indexPath) as? FavoritesCollectionViewCell else {
            return UICollectionViewCell()
        }
        let wod = viewModel.wods[indexPath.row]
        cell.delegate = self
        guard let title = wod.value(forKeyPath: "title") as? String, let description = wod.value(forKeyPath: "wodDescription") as? String else { return UICollectionViewCell() }
        let score = wod.value(forKeyPath: "score") as? String ?? "10"
        cell.setupCardCell(title: title, description: description, score: score)
        return cell

    }
}

// MARK: - UICollectionViewFlowLayout
extension ListView: UICollectionViewDelegateFlowLayout {
    func buildCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 20
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width / 1.15, height: 200)
    }
}

// MARK: - RemoveFavoriteDelegate
extension ListView: RemoveFavoriteDelegate {
    func removeFavoriteFromList(cell: UICollectionViewCell) {
        guard let indexPath = favoritesCollectionView.indexPath(for: cell) else {
            return
        }
        delegate?.presentAlertDeleteWod(at: indexPath)
    }
}
