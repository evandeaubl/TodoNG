//
//  ContentView.swift
//  TodoNG
//
//  Created by Evan Deaubl on 6/9/19.
//  Copyright © 2019 Tic Tac Code, LLC. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - view

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.keyWindow?.endEditing(force)
    }
}

final class TaskListViewData : BindableObject {
    let didChange = PassthroughSubject<TaskListViewData, Never>()
    
    var taskList: TaskList {
        didSet {
            didChange.send(self)
        }
    }
    
    init(taskList: TaskList) {
        self.taskList = taskList
        didChange.send(self)
    }
}

struct TaskListView : View {
    @ObjectBinding var taskListData: TaskListViewData
    @State var newTaskName = ""
    
    var body: some View {
        List() {
            HStack {
                TextField($newTaskName, placeholder: Text("New Task"), onCommit: {
                    let task = Task(id: self.taskListData.taskList.nextId, text: self.newTaskName, completed: false)
                    self.taskListData.taskList.tasks.insert(task, at: 0)
                    self.newTaskName = ""
                    self.endEditing(true)
                })
                Spacer()
                Image(systemName: "plus.circle.fill").foregroundColor(.green)
            }
            
            ForEach(0..<taskListData.taskList.tasks.count) { index in
                TaskRow(text: self.$taskListData.taskList.tasks[index].text, completed: self.$taskListData.taskList.tasks[index].completed)
            }.onDelete { indexSet in
                for index in indexSet {
                    self.taskListData.taskList.tasks.remove(at: index)
                }
            }
        }.navigationBarTitle(Text(taskListData.taskList.name))
    }
}

// MARK: - preview

#if DEBUG

struct TaskListView_Previews : PreviewProvider {
    static var previews: some View {
        NavigationView() {
            TaskListView(taskListData: TaskListViewData(taskList: testTaskList))
        }
    }
}

#endif
