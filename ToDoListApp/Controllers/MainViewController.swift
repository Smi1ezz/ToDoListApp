//
//  ViewController.swift
//  ToDoListApp
//
//  Created by admin on 10.03.2022.
//
import FSCalendar
import UIKit

class MainViewController: UIViewController {

    private var taskStore: StoreProtocol = TaskStore.shared

    private let router = Router(naviVC: nil)
    private lazy var selectedDate = Date()
    private lazy var sortedTasksArray = [JournalTask]()

    @IBOutlet weak var calendarView: FSCalendar!

    @IBOutlet weak var toDoListTableView: UITableView!

    @IBOutlet weak var addTaskBarButton: UIBarButtonItem!

    @IBAction private func addTaskAction(_ sender: Any) {
        print("AddTask")
        router.naviVC = self.navigationController
        router.showAddTaskVC()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("обновляем таблицу MainViewController")
        calendarView.reloadData()
        self.reloadDataOnController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toDoListTableView.register(UINib(nibName: "ToDoCell", bundle: nil), forCellReuseIdentifier: "ToDoCell")
    }

    private func reloadDataOnController() {
        sortedTasksArray = taskStore.fetchSortedTasks(byDate: selectedDate)
        toDoListTableView.reloadData()
    }

}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("view task info")
        let cell = tableView.cellForRow(at: indexPath) as! ToDoCell

        guard let name = cell.nameLabel.text else { return }

        guard name != cell.standartNameLebelText else { return }

        router.naviVC = self.navigationController

        let task = sortedTasksArray.first(where: {
            return $0.name == name
        })

        guard let currentTask = task else {return}
        router.showTaskInfoVCWithTask(task: currentTask)

    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        cell.setup(tasks: sortedTasksArray, index: indexPath.row)
        return cell
    }

}

extension MainViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        selectedDate = date
        reloadDataOnController()
    }

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return taskStore.fetchSortedTasks(byDate: date).count
    }
}

extension MainViewController: FSCalendarDataSource {

}
