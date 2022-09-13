//
//  TaskStore.swift
//  ToDoListApp
//
//  Created by admin on 07.07.2022.
//

import Foundation

protocol StoreProtocol {
    func saveTask(task: JournalTask)
    func fetchSortedTasks(byDate: Date) -> [JournalTask]
}

struct JournalTask: Decodable, Encodable {
    var id: Int?
    var dateStart: Date
    var dateFinish: Date
    var name: String
    var description: String

    init(dateStart: Date, dateFinish: Date, name: String, description: String) {
        self.dateStart = dateStart
        self.dateFinish = dateFinish
        self.name = name
        self.description = description
    }

    init(id: Int, task: JournalTask) {
        self.id = id
        self.dateStart = task.dateStart
        self.dateFinish = task.dateFinish
        self.name = task.name
        self.description = task.description
    }

    init() {
        dateStart = Date()
        dateFinish = Date()
        name = ""
        description = ""
    }

}

class TaskStore: StoreProtocol {
    public static let shared = TaskStore()

    private var storageDataJSON = Data()

    private var storageOfTasks = [JournalTask]()

    init() {
        fetchTasks()
    }

    private func fetchTasks() {

            let userDefaults = UserDefaults.standard

            guard let tasks = userDefaults.object(Data.self, with: UserDefaultsKeys.userTasks.rawValue) else {
                print("userDef nil")
                storageOfTasks = []

                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .secondsSince1970
                encoder.outputFormatting = .prettyPrinted
                let encodedTasks = try! encoder.encode(storageOfTasks)
                storageDataJSON = encodedTasks

                userDefaults.set(object: storageDataJSON, forKey: UserDefaultsKeys.userTasks.rawValue)
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970 // .millisecondsSince1970
            storageOfTasks = try! decoder.decode([JournalTask].self, from: tasks)
            print("При получении через fetchTasks() storeOfTasks в хранилище \(storageOfTasks.count)")

    }

    func saveTask(task: JournalTask) {
        let id = Int.random(in: 0...10000)

        let task = JournalTask(id: id, task: task)
        storageOfTasks.append(task)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.outputFormatting = .prettyPrinted
        let encodedTasks = try! encoder.encode(storageOfTasks)
        storageDataJSON = encodedTasks

        UserDefaults.standard.set(object: storageDataJSON, forKey: UserDefaultsKeys.userTasks.rawValue)
    }

    func fetchSortedTasks(byDate: Date) -> [JournalTask] {
        var storeOfTasksBySelectedDate = [JournalTask]()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd-MM-yyyy"

        for task in storageOfTasks {
            let stringFromTaskDate = dateFormatter.string(from: task.dateStart)
            let stringFromSelectedDate = dateFormatter.string(from: byDate)

            if stringFromTaskDate == stringFromSelectedDate {
                storeOfTasksBySelectedDate.append(task)
            }
        }

        return storeOfTasksBySelectedDate
    }

}
