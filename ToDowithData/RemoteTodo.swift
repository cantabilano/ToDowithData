//
//  ToDo.swift
//  ToDowithData
//
//  Created by Jason Yang on 1/9/24.
//

import UIKit

struct RemoteTodo : Codable {
    let id: Int
    let title: String
    var isCompleted: Bool
    let category: String
}

extension RemoteTodo { //title만 넣으면 id는 새로 생성해서 저장하는 
    init(title: String,
         category: String
    ) {
        self.id = UUID().hashValue  //ID를 만들어주는 UUID() 매소드를 사용하고 그 안에 hashValue를 저장
        self.title = title
        self.isCompleted = false
        self.category = category
    }
}
/* HashValue란 데이터를 간단한 숫자로 변환한 것
원본 데이터를 특정 규칙에 따라 처리하여 간단한 숫자로 만든 것을 해쉬값이라고 한다.

정확히는 원본 데이터 (객체)를 해쉬 함수 (hash function)을 사용하여 64bit의 Int값으로 변환한 것이다.
*/
