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
    
    var todoListData: [RemoteTodo] = [] // 할 일 목록을 저장하는 배열
    private let sharedInToDo = DataManager.shared
    
    @IBOutlet var tvListView: UITableView!
    
    //MARK: - Life Cycle
    //Life CyCle 순서 : ViewDidLoad -> ViewWillAppear -> ViewDidApear
    //뷰 전환시에는 ViewWillAppear와 ViewDidApear만 호출
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadToDoList()
        
    }
    
    private func loadToDoList() {
        let loadedTodos = sharedInToDo.getData()
        if !loadedTodos.isEmpty {
            self.todoListData = loadedTodos
            self.tvListView.reloadData()
        } else {
            sharedInToDo.setData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
        ///tvListView.reloadData()  -> 질문3 2가지 방식의 차이?
    }
    
    
    //MARK: - Action Method
    
    @IBAction func didTapAdd(_ sender: Any) {
        let alertController = UIAlertController(title: "할 일 추가", message: nil, preferredStyle: .alert)
        alertController.addTextField { textfield in textfield.placeholder = "할 일을 입력하세요." }
        let addAction = UIAlertAction(title: "추가", style: .default) {
            [weak self] _ in
            guard let self = self else { return }
            if let title = alertController.textFields?.first?.text, !title.isEmpty {
                let newTodo = RemoteTodo(id: (todoListData.last?.id ?? -1) + 1,
                                         title: title, 
                                         isCompleted: false,
                                         category: "")
                todoListData.append(newTodo)
                
                // Use DataManager to save the updated data
                sharedInToDo.updateData(with: self.todoListData)
                
                tableView?.insertRows(at: [IndexPath(row: self.todoListData.count-1, section: 0)], with: .automatic)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let dividedCategories = Set(todoListData.map{ $0.category })
        return dividedCategories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = Array(Set(todoListData.map{ $0.category }))[section]
        let todoInCategory = todoListData.filter { $0.category == category }
        return todoInCategory.count
    }
    
    // 테이블 뷰에 할 일을 표시하는 메소드
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! ToDoTableViewCell
        
        let category = Array(Set(todoListData.map { $0.category }))[indexPath.section]
        let todosInCategory = todoListData.filter { $0.category == category }
        let todoTitle = todosInCategory[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = todoTitle.title
        cell.contentConfiguration = content
        
        cell.setTask(todoListData[indexPath.row])
        
        return cell
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // 할 일을 삭제하는 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tvListView.performBatchUpdates({
                self.todoListData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }, completion: nil)
        }
        // Use DataManager to update the data after deletion
        sharedInToDo.updateData(with: self.todoListData)
    }
    
    // UserDefaults에서 데이터 순서 변경
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedItem = todoListData.remove(at: fromIndexPath.row)
        todoListData.insert(movedItem, at: to.row)
        // Use DataManager to save the reordered data
        sharedInToDo.updateData(with: self.todoListData)
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
                let selectedTodo = todoListData[selectedIndexPath.row]
                destinationDetailVC.Detailtodo = selectedTodo
            }
        }
    }
}
