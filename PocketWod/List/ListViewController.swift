//
//  ListViewController.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 03/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreData

class ListViewController: UIViewController {

    private let listView = ListView()

    // MARK: - Lifecycle
    override func loadView() {
        listView.delegate = self
        view = listView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Home"
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        title = "Favoritos"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
    }
}
extension ListViewController: DeleteWodDelegate {
    func presentAlertDeleteWod(at: IndexPath) {
        let alert = UIAlertController(title: "",
                                      message: "Remove wod from Favorites?",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Yes", style: .default) {
            [unowned self] action in
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let context = appDelegate.persistentContainer.viewContext
            context.delete(self.listView.viewModel.wods[at.row])
            self.listView.viewModel.wods.remove(at: at.row)
            let fetchRequest = NSFetchRequest<Wod>(entityName: "Wod")
            do {
                self.listView.viewModel.wods = try context.fetch(fetchRequest)
            } catch let error as NSError {
                debugPrint("Could not fetch. \(error), \(error.userInfo)")
            }
            self.listView.favoritesCollectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
