//
//  Storage.swift
//
//  Created by Don on 1/20/20.
//  Copyright © 2020 Don. All rights reserved.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    private let key: String
    private let defaultValue: T
	private let storage: UserDefaults = .standard
    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = storage.object(forKey: key) as? Data else {
                // Return defaultValue when no data in UserDefaults
                return defaultValue
            }

            // Convert data to the desire data type
			do {
				let value = try JSONDecoder().decode(T.self, from: data)
				return value
				
			} catch {
				print(error)
                return defaultValue
			}
        }
        set {
            // Convert newValue to data
			
            if let optional = newValue as? AnyOptional, optional.isNil {
				storage.removeObject(forKey: key)
            }
			else
			{
				let data = try? JSONEncoder().encode(newValue)
				storage.set(data, forKey: key)
            }
        }
    }
}
extension Storage where T: ExpressibleByNilLiteral {
    init(key: String) {
		self.init(key: key, defaultValue: nil)
    }
}


private protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
