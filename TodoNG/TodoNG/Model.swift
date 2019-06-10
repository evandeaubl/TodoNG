//
//  Model.swift
//  TodoNG
//
//  Created by Evan Deaubl on 6/9/19.
//  Copyright © 2019 Tic Tac Code, LLC. All rights reserved.
//

import SwiftUI

struct Task : Identifiable {
    var id: Int
    var text: String
    var completed: Bool
}

struct TaskList {
    var name: String
    var tasks: [Task]
    
    var nextId: Int {
        return (tasks.max(by: {task1, task2 in
            return task2.id > task1.id
        })?.id ?? 0) + 1
    }
}

#if DEBUG

var testTaskList = TaskList(name: "Tasks", tasks: [
    Task(id: 1, text: "Buy milk", completed: false),
    Task(id: 2, text: "Buy eggs", completed: true)
])

#endif
