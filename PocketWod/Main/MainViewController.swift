//
//  MainViewController.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 02/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    var viewModel = MainViewModel()
    var favoriteListViewModel = ListViewModel()
    var container: NSPersistentContainer!
    var menuOptions = MenuOptions()
    
    lazy var menuTableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.showsVerticalScrollIndicator = false
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 30
        table.layer.cornerRadius = 10
        table.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.className)
        return table
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        let mainView = MainView()
        viewModel.setupCards(.all)
        mainView.viewModel = viewModel
        mainView.alertDelegate = self
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainer()
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupMenuTable()
    }
    
    private func setupContainer() {
        container = NSPersistentContainer(name: "PocketWod")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.topItem?.title = "Home"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)]

        let leftItem = UIBarButtonItem(image: UIImage(named: "star")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(listButtonDidReceivedTouchUpInside))
        let rightItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(menuButtonDidReceivedTouchUpInside))
        leftItem.tintColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        rightItem.tintColor = #colorLiteral(red: 0.9294117647, green: 0.4, blue: 0.3882352941, alpha: 1)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = leftItem
        navigationController?.navigationBar.topItem?.rightBarButtonItem = rightItem
    }
    
    private func setupMenuTable() {
        view.addSubview(menuTableView)
        menuTableView.anchor(top: navigationController?.navigationBar.bottomAnchor, right: view.rightAnchor, rightConstant: 5, widthConstant: 170, heightConstant: 180)
        menuTableView.isHidden = true
    }
    
    @objc private func menuButtonDidReceivedTouchUpInside() {
        menuTableView.isHidden ? addMenuTableView() : removeMenuTableView()
    }
    
    @objc private func listButtonDidReceivedTouchUpInside() {
        let listViewController = ListViewController()
        navigationController?.pushViewController(listViewController, animated: true)
    }

    private func addMenuTableView() {
        UIView.animate(withDuration: 0.5) {
            self.menuTableView.isHidden = false
            self.view.bringSubviewToFront(self.menuTableView)
            self.navigationController?.navigationBar.prefersLargeTitles = false
        }
        menuTableView.reloadData()
    }
    
    private func removeMenuTableView() {
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.menuTableView.isHidden = true
        }
    }
}

// MARK: - Core Data Functions
extension MainViewController {
    func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }

}

// MARK: - Add alert delegate
extension MainViewController: AlertDelegate {
    func presentAlert(wod: Card) {
        let alert = UIAlertController(title: "",
                                      message: "Add wod to Favorites?",
                                      preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Yes", style: .default) {
            [unowned self] action in
            self.save(title: wod.title, description: wod.description)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func save(title: String, description: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Wod", in: managedContext)!
        let wod = NSManagedObject(entity: entity, insertInto: managedContext)
      
        wod.setValue(title, forKeyPath: "title")
        wod.setValue(description, forKeyPath: "wodDescription")

        do {
            try managedContext.save()
            favoriteListViewModel.wods.append(wod)
        } catch let error as NSError {
            debugPrint("Could not save. \(error), \(error.userInfo)")
        }
    }
    
}

// MARK: - TABLE VIEW EXTENSION
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = menuTableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.className, for: indexPath) as? MenuTableViewCell, let option = viewModel.optionSelected else {
            return UITableViewCell()
        }
        cell.setupMenuCell(title: menuOptions.options[indexPath.row], menu: option)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellSelected = menuTableView.cellForRow(at: indexPath) as? MenuTableViewCell,
            let mainView = view as? MainView else {
            return
        }
        let selected = setupMenu(cellSelected.option.text)
        if selected == .new {
            presentAddNewWodAlert()
            return
        }
        viewModel.setupCards(selected)
        mainView.wodCardCollectionView.reloadData()
        removeMenuTableView()
    }
    
    private func setupMenu(_ option: String?) -> Menu {
        if option == Menu.homeWods.rawValue {
            return .homeWods
        } else if option == Menu.dbWods.rawValue {
            return .dbWods
        } else if option == Menu.kbWods.rawValue {
            return .kbWods
        } else if option == Menu.heroes.rawValue {
            return .heroes
        } else if option == Menu.new.rawValue {
            return .new
        } else {
            return .all
        }
    }
    
    private func presentAddNewWodAlert() {
        present(AddWodModalViewController(), animated: true, completion: nil)
//        let alert = UIAlertController(title: "",
//                                      message: "Would you like to add an Wod?",
//                                      preferredStyle: .alert)
//
//        alert.addTextField { textField in
//            textField.placeholder = "Enter wod title: "
//        }
//        alert.addTextField { textField in
//            textField.placeholder = "Enter wod description: "
//        }
//        let saveAction = UIAlertAction(title: "Yes", style: .default) {
//            [unowned self] action in
////            self.save(title: wod.title, description: wod.description)
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel",
//                                         style: .cancel)
//        alert.addAction(saveAction)
//        alert.addAction(cancelAction)
//        present(alert, animated: true)
    }
}

class AddWodModalViewController: UIViewController {
    lazy var modalView: UIView = {
        let modal = UIView()
        modal.backgroundColor = .white
        modal.translatesAutoresizingMaskIntoConstraints = false
        return modal
    }()
    
    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Would you like to add an Wod?"
        return label
    }()
    
    lazy var inputTitleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Wod title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var inputDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overCurrentContext
        view.anchor(widthConstant: 300, heightConstant: 400)
        view.addSubview(modalView)
        modalView.anchorCenterSuperview()
        modalView.anchorTo(superview: view)
        modalView.addSubview(messageLabel)
        modalView.addSubview(inputTitleTextField)
        modalView.addSubview(inputDescriptionTextView)
        messageLabel.anchorCenterXToSuperview()
        messageLabel.anchor(top: modalView.topAnchor, topConstant: 5)
        inputTitleTextField.anchor(top: messageLabel.bottomAnchor, topConstant: 5, widthConstant: 150)
        inputTitleTextField.anchorCenterXToSuperview()
        inputDescriptionTextView.anchor(top: inputTitleTextField.bottomAnchor, topConstant: 5, widthConstant: 150, heightConstant: 250)
        inputDescriptionTextView.anchorCenterXToSuperview()
    }
}
