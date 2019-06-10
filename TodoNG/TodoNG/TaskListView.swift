//
//  ContentView.swift
//  TodoNG
//
//  Created by Evan Deaubl on 6/9/19.
//  Copyright © 2019 Tic Tac Code, LLC. All rights reserved.
//

import SwiftUI
import Combine

// MARK: - view extension

extension View {
    func endEditing(_ force: Bool) {
        UIApplication.shared.keyWindow?.endEditing(force)
    }
}

// MARK: - view model

final class TaskListViewData : BindableObject {
    let didChange = PassthroughSubject<TaskListViewData, Never>()
    
    var taskList: TaskList {
        didSet {
            didChange.send(self)
        }
    }
    
    init(taskList: TaskList) {
        self.taskList = taskList
    }
}

// MARK: - view

struct TaskListView : View {
    @ObjectBinding var taskListData: TaskListViewData
    @State var newTaskName = ""
    @Environment(\.editMode) var editMode
    
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
            }.onMove { indexSet, to in
                print("-")
                print(to)
                var movers: [Task] = []
                var newTo = to
                for index in indexSet {
                    print(index)
                    movers.append(self.taskListData.taskList.tasks.remove(at: index))
                    //if index < to {
                    //    newTo -= 1
                    //}
                }
                print(newTo)
                self.taskListData.taskList.tasks.insert(contentsOf: movers, at: newTo)
            }
            }.navigationBarTitle(Text(taskListData.taskList.name)).navigationBarItems(trailing: Button(action: {
                if self.editMode?.value == .inactive {
                    self.editMode?.value = .active
                }
                else {
                    self.editMode?.value = .inactive
                }
            }) { Image(systemName: "list.number")})
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
