//
//  ToDoTableViewController.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import SwiftUI
import UIKit

class ToDoTableViewController: UITableViewController {
    //MARK: - Properties
    
    private var todoDict: [String: [RemoteTodo]] = DataManager.shared.readAllAndCategorize()
    
    private var dataSource: [RemoteTodo] = DataManager.shared.getData()
    
    @IBOutlet var tvListView: UITableView!
    
    //MARK: - Life Cycle
    //Life CyCle 순서 : ViewDidLoad -> ViewWillAppear -> ViewDidApear
    //뷰 전환시에는 ViewWillAppear와 ViewDidApear만 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        tvListView.delegate = self
        tvListView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
        ///tvListView.reloadData()  -> 질문3 2가지 방식의 차이?
    }
    
    
    //MARK: - Action Method
    
    @IBAction func didTapAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textfiled in textfiled.placeholder = "카테고리 입력" }
        alertController.addTextField { textfield in textfield.placeholder = "할 일을 입력하세요." }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { _ in //[weak self]
            
            guard let category = alertController.textFields?[0].text, !category.isEmpty,
                  let title = alertController.textFields?[1].text, !title.isEmpty
            else {
                return
            }
            let todo = RemoteTodo(title: title, category: category)
            
            DataManager.shared.saveData(todo)
            
            self.todoDict = DataManager.shared.readAllAndCategorize()
            self.tvListView.reloadData()
            
            alertController.dismiss(animated: true)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}
// MARK: - Table view data source

extension ToDoTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    // 테이블 뷰에 할 일을 표시하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.reuseIdentifier, for: indexPath) as? ToDoTableViewCell else {
            return ToDoTableViewCell()
        }
        let todo = dataSource[indexPath.row]
        
        cell.configure(with: todo)
        //cell의 delegate 속성을 넣어야 한다.
        cell.delegate = self 
        // tableviewcontroller의 인스턴스, 프로토콜을 채택한 타입은 프로토콜 타입으로 취급할 수 있다.


        //        let category = Array(Set(todoListData.map { $0.category }))[indexPath.section]
        //        let todosInCategory = todoListData.filter { $0.category == category }
        ////        let todoTitle = todosInCategory[indexPath.row]
        //
        //        var content = cell.defaultContentConfiguration()
        //        content.text = todoTitle.title
//        //        cell.contentConfiguration = content
//        
//        cell.setTask(dataSource[indexPath.row])
        
        return cell
    }
    
    //extension ViewController: UITableViewDelegate, UITableViewDataSource {
    ///tableViewController는 UITableViewDelegate, UITableViewDataSource 프로토콜을 채택하지 않는 이유?
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //슬라이드하여 삭제하려할 때 할 일을 삭제하는 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // RemoteDoto 삭제
            
            let id = dataSource[indexPath.row].id // 지우려고하는 데이터에 접근
            
            DataManager.shared.deleteData(todoId: id) //id를 가진 todo를 지워줘
            
            //반복된다면 매소드로 추출할 수 도 있다.
            self.todoDict = DataManager.shared.readAllAndCategorize()
            self.tvListView.reloadData() // 새로운 데이터소스를 리로드
        }
    }
    
    // UserDefaults에서 데이터 순서 변경
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedItem = dataSource.remove(at: fromIndexPath.row)
        dataSource.insert(movedItem, at: to.row)
        
    }
    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgDetail" {
            if let destinationDetailVC = segue.destination as? DetailViewController,
               let selectedIndexPath = tableView.indexPathForSelectedRow {
                let selectedTodo = dataSource[selectedIndexPath.row]
                destinationDetailVC.Detailtodo = selectedTodo
            }
        }
    }
}

extension ToDoTableViewController: ToDotvCellDelegate {
    func changedSwitch(todoid: Int, isCompleted: Bool) {
        //TODO: Todo Update
        
        DataManager.shared.updateData(todoId: todoid, isCompleted: isCompleted)
        
        self.dataSource = DataManager.shared.getData()
        
        self.tvListView.reloadData()
    }
}
