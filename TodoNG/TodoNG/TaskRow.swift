//
//  TaskRow.swift
//  TodoNG
//
//  Created by Evan Deaubl on 6/9/19.
//  Copyright © 2019 Tic Tac Code, LLC. All rights reserved.
//

import SwiftUI

struct TaskRow : View {
    @Binding var text: String
    @Binding var completed: Bool
    
    var body: some View {
        HStack() {
            Text(text).foregroundColor(completed ? .gray : .primary)
            Spacer()
            Button(action: {
                self.completed = !self.completed
            }) {
                if completed {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.gray)
                }
                else {
                    Image(systemName: "circle")
                }
            }
        }
    }
}

#if DEBUG

struct TaskRow_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(0..<testTaskList.tasks.count) { index in
                // TODO these don't actually update the value...
                TaskRow(text: Binding<String>.constant(testTaskList.tasks[index].text), completed: Binding<Bool>.constant(testTaskList.tasks[index].completed))
            }
        }.previewLayout(.fixed(width: 360, height: 30))
    }
}
#endif
