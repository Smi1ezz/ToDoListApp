//
//  TaskModel.swift
//  ToDoListApp
//
//  Created by admin on 13.03.2022.
//

import Foundation

protocol StoreProtocol {
    func saveTask(task: JournalTask) -> Int
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

class MockedTaskStore: StoreProtocol {

    public static let shared = MockedTaskStore()

    private var mockedJSON = """
    [
    {
    "id":1,
    "dateStart":1647197228.691479,
    "dateFinish":1647197681,
    "name":"My task 1",
    "description":"Описание моего дела 1"
    },
    {
    "id":2,
    "dateStart":1647397228,
    "dateFinish":1657197681,
    "name":"My task 2",
    "description":"Описание моего дела 2"
    }
    ]
    """.data(using: .utf8)!

    private lazy var storeOfTasks = [JournalTask]()

    init() {
        fetchTasks()
    }

    func saveTask(task: JournalTask) -> Int {
        let id = Int.random(in: 0...10000)

        let task = JournalTask(id: id, task: task)
        storeOfTasks.append(task)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .secondsSince1970
        encoder.outputFormatting = .prettyPrinted
        let encodedTasks = try! encoder.encode(storeOfTasks)
        mockedJSON = encodedTasks

        return id
    }

    private func fetchTasks() {

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970 // .millisecondsSince1970
        self.storeOfTasks = try! decoder.decode([JournalTask].self, from: mockedJSON)
        print("При получении массива через fetchTasks() storeOfTasks в хранилище \(storeOfTasks.count)")
    }

    func fetchSortedTasks(byDate: Date) -> [JournalTask] {
        var storeOfTasksBySelectedDate = [JournalTask]()
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "dd-MM-yyyy"

        for task in storeOfTasks {
            let stringFromTaskDate = dateFormatter.string(from: task.dateStart)
            let stringFromSelectedDate = dateFormatter.string(from: byDate)

            if stringFromTaskDate == stringFromSelectedDate {
                storeOfTasksBySelectedDate.append(task)
            }
        }

        return storeOfTasksBySelectedDate
    }

}
