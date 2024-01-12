//
//  DataManager.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//
import UIKit
import Foundation


final class DataManager {
    
    static let shared: DataManager = .init()
    
    private let key = "todoList"
    
    private init() {
//        super.init()
    }
    
    // 디코딩된 데이터를 ToDo 객체 배열로 반환
    // UserDefaults에서 저장된 데이터를 가져와서 디코딩하여 RemoteTodo 객체의 배열로 반환
    func getData() -> [RemoteTodo] { //realAll
        guard let encodedData = UserDefaults.standard.data(forKey: key),
              let todoList = try? JSONDecoder().decode([RemoteTodo].self, from: encodedData)
        else {
            return []
        }
        return todoList
    }
    /// guard let 옵셔널 바인딩과 do catch문의 차이?
//        if let encodedData = UserDefaults.standard.data(forKey: key) {
//            let decoder = JSONDecoder()
//            do {
//                let decodedData = try decoder.decode([RemoteTodo].self, from: encodedData)
//                return decodedData
//            } catch {
//                print("Failed to load todos: \(error.localizedDescription)")
//            }
//        }
        // 데이터 불러오기 실패 시 빈 배열 반환

//    
//    func setData() {
//        // 프로퍼티 배열 생성
//        let todos : [RemoteTodo] = [
//            RemoteTodo(id: 0, title: "title1", isCompleted: false, category: "운동"),
//            RemoteTodo(id: 1, title: "title2", isCompleted: false, category: "운동"),
//            RemoteTodo(id: 2, title: "title3", isCompleted: false, category: "생활"),
//            RemoteTodo(id: 3, title: "title4", isCompleted: false, category: "생활")
//        ]
//        saveData(todos)
//    }
    
    func saveData(_ todos: RemoteTodo) { // add
        
        var todoList = getData()
        
        todoList.append(todos)
        
        guard let data = try? JSONEncoder().encode(todoList) else {
            return
        }
        UserDefaults.standard.setValue(data, forKey: key)
        // JASON형식으로 인코딩된 데이터를 UserDefaults에 저장, 이렇게 하면 ToDo 목록이 앱이 종료되어도 유지됨.
//        let encoder = JSONEncoder()
//        do { // encode는 throw 형식이기 때문에 try를 쓴다.
//            let encodedData = try encoder.encode(todos)
//            // 인코드된 encodedData을 serDefaults를 이용해서 key에 저장 set과 setValue 차이?
//            UserDefaults.standard.setValue(encodedData, forKey: key)
//        } catch {
//            print("Failed to save todos: \(error.localizedDescription)")
//        }
    }
    func readAllAndCategorize() -> [String: [RemoteTodo]] {
        let todoList = getData()
        return Dictionary(grouping: todoList) {
            RemoteTodo in RemoteTodo.category
        }
        
    }
    // "todoList" 키에 해당하는 데이터 삭제, removeOject 매소드 사용
    func deleteData(todoId: Int) {
        
        var todoList = getData()  // 불러온 다음 지워야 한다. 
        //RemoteTodo에서 RemoteTodo.id에서 내가 지우려는 todoID와 같으면 지워
        todoList.removeAll() { RemoteTodo in RemoteTodo.id == todoId
        }
        // 원하는 Todo 가 지워진 상태
        
        // 지워진 후 상태를 저장
        guard let data = try? JSONEncoder().encode(todoList) else {
            return
        }
        // 지워진 상태를 setValue로 데이터에 key를 저장
        UserDefaults.standard.setValue(data, forKey: key)
        //UserDefaults.standard.removeObject(forKey: key) removeObject를 쓰지 않는 이유?
        
    }
    // 업데이트된 ToDo 목록을 인코딩하여 UserDefaults에 저장, 기존 데이터를 덮어쓰는 역할
    // 배열에서 id를 찾아야한다.
    func updateData(todoId: Int, title: String? = nil, isCompleted: Bool? = nil) {
        var todoList = getData()
        
        guard let searchIndex = todoList.firstIndex(where: { $0.id == todoId})
        else {
            return
        }
        
        //todoList의 subscript로 하나의 배열에 접근
        if let newtitle = title {
            todoList[searchIndex].title = newtitle
        }
        if let newIsComplete = isCompleted {
            todoList[searchIndex].isCompleted = newIsComplete
        }
        
        // 리스트가 업데이트된 상태
        guard let data = try? JSONEncoder().encode(todoList) else {
            return
        }
        // 중복이 되면 같은 코드가 반복되면 매소드로 추출하는게 좋다.
        UserDefaults.standard.setValue(data, forKey: key)
//        let encoder = JSONEncoder()
//        do {
//            let encodedData = try encoder.encode(updatedList)
//            UserDefaults.standard.set(encodedData, forKey: key)
//        } catch {
//            print("Failed to update todos: \(error.localizedDescription)")
//        }
    }
}

/// 참고
//let sampleData1 [[String: Any]]= [
//  [
//    "id" : UUID().hashValue,
//    "description" : "책상 정리"
//    "isDone" : false,
//  ],
//  [
//    "id" : UUID().hashValue,
//    "description" : "먼지 털기"
//    "isDone" : true,
//  ],
//]


//let sampleData2: Data =
//"""
//[
//  {
//    "id" : 123129123213,
//    "description" : "책상 정리"
//    "isDone" : false,
//  },
//
//  {
//    "id" : 311293801298,,
//    "description" : "먼지 털기"
//    "isDone" : false,
//  }
//]
//"""
