//
//  ToDoTableViewCell.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var doneSwitch: UISwitch!
    
    var cellTodo: RemoteTodo?
    
    @IBAction func changedSwitch(_ sender: Any) {
        //guard let 구문을 사용하여 옵셔널 바인딩을 수행할 때는, 바인딩할 변수 또는 상수의 이름을 정확히 명시해야 함
        if doneSwitch.isOn {
            textLabel?.text = nil
            textLabel?.attributedText = cellTodo?.title.strikeThrough()
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = cellTodo?.title
        }
    }
    
    func setTask(_ receivedToDo: RemoteTodo) {
        cellTodo = receivedToDo
        guard let cellTodo else { return }
        if cellTodo.isCompleted {
            textLabel?.text = nil
            textLabel?.attributedText = cellTodo.title.strikeThrough()
        } else {
            textLabel?.attributedText = nil
            textLabel?.text = cellTodo.title
        }
        doneSwitch.isOn = cellTodo.isCompleted
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
