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
    @Published var presets: [Preset] = []
    @Published var shift: Shift?
    @Published var canEdit: Bool
    @Published var edit: Bool = false
    var webService = WebService()
    
    typealias UpdateFieldsClosure = (Array<String?>) -> Void
    typealias UsePresetClosure = (Array<Date>?) -> Void
    
    func loadEmployees() {
        webService.loadEmployees() { result in
            if result != nil {
                self.employees = result!
            }
        }
    }
    
    func loadPresets(currentDate: Date) {
        webService.loadPresets { result in
            self.presets = result!
        }
    }
    
    init(withShift newShift: Shift, canEdit flag: Bool) {
        self.shift = newShift
        self.canEdit = flag
        loadEmployees()
    }
    
    func setEmployees(_ users: [User]) {
        employees = users
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
    
    func usePreset(currentDate: Date, selectedPreset: String) -> [Date] {
        var result: [Date] = []
        if selectedPreset == "" {
            result.append(currentDate)
            result.append(currentDate)
        } else {
            let preset = presets.filter { $0.name == selectedPreset }
            result.append(preset[0].getStartTime(currentDate: currentDate))
            result.append(preset[0].getEndTime(currentDate: currentDate))
            print(result)
            let timestamp1 = Timestamp(date: result[0])
            let timestamp2 = Timestamp(date: result[1])
            if timestamp1.compare(timestamp2).rawValue > 0 {
                result[1] = Calendar.current.date(byAdding: .day, value: 1, to: result[1])!
            }
            print(result)
        }
        return result
    }
}
