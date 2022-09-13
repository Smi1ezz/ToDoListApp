//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by admin on 13.03.2022.
//

import UIKit

class AddTaskViewController: UIViewController {

    enum InfoViewControllerState {
        case create
        case info
    }

    private lazy var newTask = JournalTask()
    var viewControllerState: InfoViewControllerState = .create

    private let nameTextField: CustomTextField = {
        let name = CustomTextField()
        name.layer.borderWidth = 1
        name.layer.borderColor = UIColor.black.cgColor
        name.layer.cornerRadius = 10
        name.backgroundColor = .white
        name.tintColor = .blue
        name.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return name
    }()

    private let dateTextField: CustomTextField = {
       let date = CustomTextField()
        date.backgroundColor = .white
        date.layer.borderWidth = 1
        date.layer.borderColor = UIColor.black.cgColor
        date.layer.cornerRadius = 10
        return date
    }()

    private let timeTextField: CustomTextField = {
         let time = CustomTextField()
         time.backgroundColor = .white
         time.layer.borderWidth = 1
         time.layer.borderColor = UIColor.black.cgColor
         time.layer.cornerRadius = 10
         return time
     }()

    private let descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.cornerRadius = 10
        return descriptionTextView
    }()

    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.backgroundColor = .blue
        saveButton.tintColor = .white
        saveButton.layer.cornerRadius = 10
        return saveButton
    }()

    override func viewWillAppear(_ animated: Bool) {
        setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()

        setupSubviews()
    }

    // swiftlint:disable:next function_body_length
    private func setupSubviews() {

        let subViews = [nameTextField, dateTextField, timeTextField, descriptionTextView, saveButton]

        for subView in subViews {
            view.addSubview(subView)
        }

        if viewControllerState == .create {
            self.title = "Создать задачу"
            view.backgroundColor = .white

            for item in [nameTextField, dateTextField, timeTextField, descriptionTextView] {
                item.isUserInteractionEnabled = true
            }
            for item in [nameTextField, dateTextField, timeTextField] {
                item.text = nil
            }

            nameTextField.placeholder = "Введите дело"

            dateTextField.placeholder = "На какое число планируем?"
            dateTextField.setDatePickerAsInputView(datePickerMode: .date) { date in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let dateString = dateFormatter.string(from: date)
                return dateString
            }

            timeTextField.placeholder = "В какое время выполняем?"
            timeTextField.setDatePickerAsInputView(datePickerMode: .time) { time in
                let dateFormatter = DateFormatter()
                dateFormatter.locale = .current
                dateFormatter.dateFormat = "HH"
                let timeString = dateFormatter.string(from: time)
                return timeString + ":00"
            }

            descriptionTextView.text = "Описание дела"

            saveButton.setTitle("Сохранить", for: .normal)
            saveButton.removeTarget(nil, action: #selector(backButtonAction), for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(saveNewTaskAction), for: .touchUpInside)

            setConstraints()

        } else if viewControllerState == .info {
            self.title = "Подробности"
            view.backgroundColor = .white

            for item in [nameTextField, dateTextField, timeTextField, descriptionTextView] {
                item.isUserInteractionEnabled = false
            }
            for item in [nameTextField, dateTextField, timeTextField] {
                item.placeholder = ""
            }

            descriptionTextView.text = "нет описания"

            saveButton.setTitle("Назад", for: .normal)
            saveButton.backgroundColor = .red
            saveButton.removeTarget(nil, action: #selector(backButtonAction), for: .touchUpInside)
            saveButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)

            setConstraints()
        }
    }

    private func setConstraints() {
        let subViews = [nameTextField, dateTextField, timeTextField, descriptionTextView, saveButton]

        for subView in subViews {
            subView.translatesAutoresizingMaskIntoConstraints = false
        }

        let leftOffset: CGFloat = 16
        let rightOffset: CGFloat = -16
        let spacing: CGFloat = 30
        let topOffset: CGFloat = 50
        let bottomOffset: CGFloat = -50
        let textFieldHeight: CGFloat = 50

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topOffset),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftOffset),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightOffset),
            nameTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            dateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: spacing),
            dateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftOffset),
            dateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightOffset),
            dateTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            timeTextField.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: spacing),
            timeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftOffset),
            timeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightOffset),
            timeTextField.heightAnchor.constraint(equalToConstant: textFieldHeight),

            descriptionTextView.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: spacing),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leftOffset),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rightOffset),

            saveButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: spacing),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 3*leftOffset),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 3*rightOffset),
            saveButton.heightAnchor.constraint(equalToConstant: textFieldHeight),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset)
        ])
    }

    func setNewTask(_ task: JournalTask) {
        newTask = task
        nameTextField.text = newTask.name
        dateTextField.text = getDateFromDate(date: newTask.dateStart)
        timeTextField.text = getTimeFromDate(date: newTask.dateStart)
        descriptionTextView.text = newTask.description
    }

    private func getDateFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }

    private func getTimeFromDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "HH"
        let timeString = dateFormatter.string(from: date) + ":00"
        return timeString
    }

    @objc
    func saveNewTaskAction() {
        if let taskName = nameTextField.text, !taskName.isEmpty {
            newTask.name = taskName
        } else {
            newTask.name = "НЕ ВВЕЛИ"
        }

        guard let date = (dateTextField.inputView as? UIDatePicker)?.date,
              let time = (timeTextField.inputView as? UIDatePicker)?.date else {
                  let alertVC = UIAlertController(title: "Alert", message: "Введите дату и время", preferredStyle: .alert)
                  alertVC.addAction(UIAlertAction(title: "Иду вводить", style: .destructive, handler: nil))
                  self.present(alertVC, animated: true, completion: nil)
                  return
              }

        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour], from: time)
        dateComponents.setValue(timeComponents.hour, for: .hour)
        newTask.dateStart = calendar.date(from: dateComponents) ?? Date()
        newTask.dateFinish = newTask.dateStart + 3600
        newTask.description = descriptionTextView.text

        TaskStore.shared.saveTask(task: newTask)

        print("добавлена задача \(newTask.name), на дату \(newTask.dateStart)")

        navigationController?.popViewController(animated: true)

    }

    @objc
    func backButtonAction() {
        print("назад к главному экрану")

        navigationController?.popViewController(animated: true)

    }

}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
