//
//  UserDefExt.swift
//  ToDoListApp
//
//  Created by admin on 13.09.2022.
//

import Foundation

enum UserDefaultsKeys: String {
    /// хранит массив добавленных JournalTask. По умолчанию пустой массив.
    case userTasks
}

extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
