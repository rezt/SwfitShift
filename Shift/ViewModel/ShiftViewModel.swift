//
//  ShiftViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 04/12/2021.
//

import Foundation
import Firebase
import SwiftUI

final class ShiftViewModel: ObservableObject {
    
    @Published var employees: [User] = []
    @Published var shift: Shift?
    @Published var canEdit: Bool
    @Published var edit: Bool = false
    var webService = WebService()
    
    typealias UpdateFieldsClosure = (Array<String?>) -> Void
    
    func loadEmployees() {
        webService.loadEmployees() { result in
            if result != nil {
                self.employees = result!
            }
        }
    }
    
    init(withShift newShift: Shift, canEdit flag: Bool) {
        self.shift = newShift
        self.canEdit = flag
        loadEmployees()
    }
    
    func updateFields(completionHandler: @escaping UpdateFieldsClosure) {
        webService.getDetails(forUserID: shift!.employee) { result in
            completionHandler([result![0].name, result![0].role])
        }
    }
    
    func editShift() {
        print(shift)
        edit = !edit
    }
}
