//
//  ToDoCell.swift
//  ToDoListApp
//
//  Created by admin on 13.03.2022.
//

import UIKit

class ToDoCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!

    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    let standartNameLebelText = "Нет дел"

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = standartNameLebelText
        self.accessoryType = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setup(tasks: [JournalTask], index: Int) {
        let start = String(format: "%02d", index)
        let finish = String(format: "%02d", index + 1)
        dateLabel.text = "\(start):00 - \(finish):00"

        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "HH"

        let task = tasks.first(where: {
            let startHour = dateFormatter.string(from: $0.dateStart)
            return startHour == start
        })

        self.nameLabel.text = task?.name ?? self.standartNameLebelText

        self.accessoryType = task != nil ? .disclosureIndicator : .none
    }

}
