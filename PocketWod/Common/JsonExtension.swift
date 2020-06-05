//
//  JsonExtension.swift
//  PocketWod
//
//  Created by Gabriela Coelho on 02/04/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import Foundation

class Json {
    class func deserialize(data: Data) -> [String: Any]? {
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return jsonDict as? [String: Any]
        } catch {
            return nil
        }
    }
    
    class func parseJsonFromResource(_ resource: String) -> Data? {
        guard let path = Bundle(for: self).url(forResource: resource,
                                               withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: path)
//            let json = String(bytes: jsonData, encoding: .utf8)
            return data
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        return nil
    }
}
