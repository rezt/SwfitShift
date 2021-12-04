//
//  TaskViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/11/2021.
//

import Foundation
import Firebase
import SwiftUI

final class TaskViewModel: ObservableObject {
    @Published var task: Task?
    @Published var canEdit: Bool
    @Published var edit: Bool = false
    
    init(withTask newTask: Task, canEdit flag: Bool) {
        self.task = newTask
        self.canEdit = flag
    }
    
    func editTask() {
        print(task)
        edit = !edit
    }
}

