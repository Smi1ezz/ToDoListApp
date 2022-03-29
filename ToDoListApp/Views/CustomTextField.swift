//
//  customTextField.swift
//  ToDoListApp
//
//  Created by admin on 28.03.2022.
//

import UIKit

class CustomTextField: UITextField {

    private var formatResult: ((Date) -> String)?

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 10, y: 0, width: bounds.width, height: bounds.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    func setDatePickerAsInputView(datePickerMode: UIDatePicker.Mode = .date, formatResult: @escaping (Date) -> String) {
        self.formatResult = formatResult
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        self.inputView = datePicker
    }

    override func becomeFirstResponder() -> Bool {
        if let datePicker = inputView as? UIDatePicker {
            self.text = formatResult?(datePicker.date)
        }
        return super.becomeFirstResponder()

    }

    @objc func dateChanged(_ sender: UIDatePicker) {
        text = formatResult?(sender.date)
    }
}
