//
//  DataManager.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//
import UIKit

struct UserDefaultsKeys {
    static let todoList = "todoList"
}

class DataManager: NSObject {
    static let shared = DataManager()
    
    private override init() {
        super.init()
    }
    
    func setData() {
        // 프로퍼티 배열 생성
        let todos : [RemoteTodo] = [
            RemoteTodo(id: 0, title: "title1", isCompleted: false, category: "운동"),
            RemoteTodo(id: 1, title: "title2", isCompleted: false, category: "운동"),
            RemoteTodo(id: 2, title: "title3", isCompleted: false, category: "생활"),
            RemoteTodo(id: 3, title: "title4", isCompleted: false, category: "생활")
        ]
        saveData(todos)
    }
    
    func saveData(_ todos: [RemoteTodo]) {
        // JASON형식으로 인코딩된 데이터를 UserDefaults에 저장, 이렇게 하면 ToDo 목록이 앱이 종료되어도 유지됨.
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(todos)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.todoList)
        } catch {
            print("Failed to save todos: \(error.localizedDescription)")
        }
    }
    
    // 디코딩된 데이터를 ToDo 객체 배열로 반환
    // UserDefaults에서 저장된 데이터를 가져와서 디코딩하여 RemoteTodo 객체의 배열로 반환
    func getData() -> [RemoteTodo] {
        if let encodedData = UserDefaults.standard.data(forKey: UserDefaultsKeys.todoList) {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode([RemoteTodo].self, from: encodedData)
                return decodedData
            } catch {
                print("Failed to load todos: \(error.localizedDescription)")
            }
        }
        // 데이터 불러오기 실패 시 빈 배열 반환
        return []
    }
    
    // 업데이트된 ToDo 목록을 인코딩하여 UserDefaults에 저장, 기존 데이터를 덮어쓰는 역할
    func updateData(with updatedList: [RemoteTodo]) {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(updatedList)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsKeys.todoList)
        } catch {
            print("Failed to update todos: \(error.localizedDescription)")
        }
    }
    
    // "todoList" 키에 해당하는 데이터 삭제, removeOject 매소드 사용
    func deleteData() {
        UserDefaults.standard.removeObject(forKey: "todoList")
    }
}
