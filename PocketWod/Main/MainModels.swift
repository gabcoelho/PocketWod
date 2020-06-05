//
//  MainModels.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 07/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import Foundation

enum Menu: String {
    case homeWods = "Home Wods"
    case dbWods = "Dumbbell Wods"
    case kbWods = "Kettlebell Wods"
    case heroes = "Hero Wods"
    case all = "All"
    case new = "Add New"
}

struct Card: Decodable {
    let title: String
    let description: String
    let score: String?
    
    init(
        title: String,
        description: String,
        score: String? = nil
    ) {
        self.title = title
        self.description = description
        self.score = score
    }
}


struct WodCards: Decodable {
    var cards: [Card]
}

class MainViewModel {
    
    var wods: WodCards?
    var optionSelected: Menu?
    
    func setupCards(_ selected: Menu) {
        switch selected {
        case .homeWods:
            optionSelected = .homeWods
            let cardsJson = Json.parseJsonFromResource("homeWods")
            if let data = cardsJson {
                do {
                    let resultObject = try JSONDecoder().decode(WodCards.self, from: data)
                    wods = resultObject
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        case .dbWods:
            optionSelected = .dbWods
            let cardsJson = Json.parseJsonFromResource("dbWods")
            if let data = cardsJson {
                do {
                    let resultObject = try JSONDecoder().decode(WodCards.self, from: data)
                    wods = resultObject
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        case .kbWods:
            optionSelected = .kbWods
            let cardsJson = Json.parseJsonFromResource("kbWods")
            if let data = cardsJson {
                do {
                    let resultObject = try JSONDecoder().decode(WodCards.self, from: data)
                    wods = resultObject
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        case .heroes:
            optionSelected = .heroes
            let cardsJson = Json.parseJsonFromResource("heroWods")
            if let data = cardsJson {
                do {
                    let resultObject = try JSONDecoder().decode(WodCards.self, from: data)
                    wods = resultObject
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        case .all:
            optionSelected = .all
            let cardsJson = Json.parseJsonFromResource("heroWods")
            if let data = cardsJson {
                do {
                    let resultObject = try JSONDecoder().decode(WodCards.self, from: data)
                    wods = resultObject
                } catch let error {
                    debugPrint(error.localizedDescription)
                }
            }
        case .new:
            optionSelected = .new
        }
    }
}

struct MenuOptions {
    let options = ["Home Wods", "Dumbbell Wods", "Kettlebell Wods", "Hero Wods", "All", "Add New"]
}
