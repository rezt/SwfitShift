//
//  TaskViewModel.swift.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/11/2021.
//

import Foundation
import Firebase
import SwiftUI

final class TaskViewModel: ObservableObject {
    @Published var task: Task? = nil
    @Published var canEdit: Bool = false
}

