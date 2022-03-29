//
//  Router.swift
//  ToDoListApp
//
//  Created by admin on 13.03.2022.
//

import Foundation
import UIKit

class Router {
    var naviVC: UINavigationController?

    init(naviVC: UINavigationController?) {
        self.naviVC = naviVC
    }

    func showAddTaskVC() {
        let addVC = AddTaskViewController()
        addVC.viewControllerState = .create

        naviVC?.pushViewController(addVC, animated: true)
    }

    func showTaskInfoVCWithTask(task: JournalTask) {
        let addVC = AddTaskViewController()
        addVC.viewControllerState = .info
        addVC.setNewTask(task)
        naviVC?.pushViewController(addVC, animated: true)
    }

}
