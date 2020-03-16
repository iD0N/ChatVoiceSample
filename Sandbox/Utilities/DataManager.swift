//
//  DataManager.swift
//
//  Created by Don on 8/23/19.
//  Copyright © 2019 Don. All rights reserved.
//

import Foundation

class DataManager {
	
	// MARK: - Localized Info and links
	static var standard = DataManager()
	
	
	// MARK: - Token Management
	@Storage(key: "messages", defaultValue: [])
	var messages: [MessageModel]
	
}

extension UserDefaults {
	func decode<T : Codable>(for type : T.Type, using key : String) -> T? {
		let defaults = UserDefaults.standard
		guard let data = defaults.object(forKey: key) as? Data else {return nil}
		let decodedObject = try? PropertyListDecoder().decode(type, from: data)
		return decodedObject
	}
	
	func encode<T : Codable>(for type : T, using key : String) {
		let defaults = UserDefaults.standard
		let encodedData = try? PropertyListEncoder().encode(type)
		defaults.set(encodedData, forKey: key)
		defaults.synchronize()
	}
}
