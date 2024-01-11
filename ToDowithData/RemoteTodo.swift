//
//  ToDo.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import UIKit

struct RemoteTodo : Codable {
    var id: Int
    var title: String
    var isCompleted: Bool
    var category: String
}
