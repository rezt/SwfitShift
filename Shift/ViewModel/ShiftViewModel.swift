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
    
    @Published var firstEmployees: [User] = []
    @Published var secondEmployees: [User] = []
    @Published var thirdEmployees: [User] = []
    @Published var fourthEmployees: [User] = []
    @Published var employees: [User] = []
    @Published var presets: [Preset] = []
    @Published var shift: Shift?
    @Published var canEdit: Bool
    @Published var edit: Bool = false
    private var todayDisposition: Disposition?
        
    typealias UpdateFieldsClosure = (Array<String?>) -> Void
    typealias UsePresetClosure = (Array<Date>?) -> Void
    
    init(withShift newShift: Shift, withEmployees newEmployees: [User], canEdit flag: Bool) {
        self.shift = newShift
        self.canEdit = flag
        self.employees = newEmployees
    }
    
    func loadDisposition(date: Date) {
        let result1 = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)
        let result2 = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        WebService.shared.loadDay(forDay: [result1!, result2!]) { result in
            if result != nil {
                self.todayDisposition = result![0]
                self.sortEmployees()
            }
        }
    }
    
    func detachDisposition() {
        WebService.shared.detachListener(WebService.shared.dayListener)
    }
    
    func loadPresets(currentDate: Date) {
        WebService.shared.loadPresets { result in
            self.presets = result!
        }
    }
    
    func detachPresets() {
        WebService.shared.detachListener(WebService.shared.presetListener)
    }
    
    func sortEmployees() {
        
        firstEmployees = []
        secondEmployees = []
        thirdEmployees = []
        fourthEmployees = []
        
        print("sorting employees")
        for available in todayDisposition!.available {
            let employee = employees.filter { $0.uid == available }
            if !employee.isEmpty {
                firstEmployees.append(employee[0])
            }
        }
        for notPreferred in todayDisposition!.notPreferred {
            let employee = employees.filter { $0.uid == notPreferred }
            if !employee.isEmpty {
                secondEmployees.append(employee[0])
            }
        }
        for unavailable in todayDisposition!.unavailable {
            let employee = employees.filter { $0.uid == unavailable }
            if !employee.isEmpty {
                thirdEmployees.append(employee[0])
            }
        }
        for unknown in todayDisposition!.unknown {
            let employee = employees.filter { $0.uid == unknown }
            if !employee.isEmpty {
                fourthEmployees.append(employee[0])
            }
        }
    }
    
    func updateFields(completionHandler: @escaping UpdateFieldsClosure) {
        WebService.shared.getDetails(forUserID: shift!.employee) { result in
            completionHandler([result![0].name, result![0].role])
        }
    }
    
    func editShift() {
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
