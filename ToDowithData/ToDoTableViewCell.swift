//
//  ToDoTableViewCell.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//
// ToDOTableViewController에 접근하기 위한 delegate 정의
protocol ToDotvCellDelegate: AnyObject { // 클래스만 선언할 수 있는 타입 AnyObject
    func changedSwitch(todoid: Int, isCompleted: Bool)
}

import UIKit

class ToDoTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: ToDoTableViewCell.self)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneSwitch: UISwitch!
    
    var cellTodo: RemoteTodo?
    
    weak var delegate: ToDotvCellDelegate?
    
    @IBAction func changedSwitch(_ sender: UISwitch) {
        //Value of optional type 'Int?' must be unwrapped to a value of type 'Int'
        //옵셔널 RemoteTodo? 타입이기때문에 cellTodo?.id -> cellTodo는 옵셔널 바인딩을 해줘야 한다.
        guard let id = cellTodo?.id else { return }
        //vc로 직접 접근하는 방법인 var vc: ToDoTableViewController로 타입을 지정하면 다른 vc에서 접근할 수 없기 때문에
        //protocol ToDotvCellDelegate 채택한 어떠한 vc도 접근할 수 있는 유연성이 있다.
        delegate?.changedSwitch(todoid: id, isCompleted: sender.isOn)
        print()
    }
    
    func configure(with todoFromRemoteTodo: RemoteTodo) {
      self.cellTodo = todoFromRemoteTodo
      titleLabel.text = todoFromRemoteTodo.title
      doneSwitch.isOn = todoFromRemoteTodo.isCompleted
    }
    
//    func setTask(_ receivedToDo: RemoteTodo) {
//        cellTodo = receivedToDo
//        guard let cellTodo else { return }
//        if cellTodo.isCompleted {
//            textLabel?.text = nil
//            textLabel?.attributedText = cellTodo.title.strikeThrough()
//        } else {
//            textLabel?.attributedText = nil
//            textLabel?.text = cellTodo.title
//        }
//        doneSwitch.isOn = cellTodo.isCompleted
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
