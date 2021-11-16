//
//  TaskView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import SwiftUI

struct TaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    
    var body: some View {
        Form {
            Text("test")
                .foregroundColor(.white)
        }.foregroundColor(.black)
    }
}

struct TaskView_Previews: PreviewProvider {
    @StateObject var taskViewModel = TaskViewModel()
    static var previews: some View {
        let test = TaskView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskView(taskViewModel: test.taskViewModel)
        }
    }
}
