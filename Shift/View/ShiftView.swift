//
//  ShiftView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 29/11/2021.
//

import Foundation
import SwiftUI
import Firebase

struct ShiftView: View {
    
    var currentUser: User
    @ObservedObject var shiftViewModel: ShiftViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
    @State var selectedEmployee: String = "test"
    @State var selectedEmployeeName: String = ""
    @State var selectedTeam: String = "test"
    @State var selectedTeamName: String = ""
    @State var selectedPreset: String = ""
    @State var upForGrabsField: Bool = false
    @State var endDate: Date = Date()
    @State var startDate: Date = Date()
    @State var usingPreset: Bool = false
    @State var presetDate: Date = Date()
    @State var alreadySeen: Bool = false
    @Environment(\.presentationMode) var presentationMode
    
    init(_ user: User, shiftViewModel: ShiftViewModel, calendarViewModel: CalendarViewModel) {
        UITableView.appearance().backgroundColor = .clear
        self.currentUser = user
        self.shiftViewModel = shiftViewModel
        self.calendarViewModel = calendarViewModel
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    if self.$shiftViewModel.edit.wrappedValue { // Edit view
                        Picker(selection: $selectedPreset, label: Text("🗂 Preset:").foregroundColor(.black)) {
                            ForEach(shiftViewModel.presets, id: \.self) { preset in
                                Text(preset.name).foregroundColor(.black).tag(preset.name)
                            }
                        }.onChange(of: selectedPreset) { preset in
                            
                            self.usingPreset = true
                        }
                        Picker(selection: $selectedEmployee, label: Text("📌 Employee:").foregroundColor(.black)) {
                            ForEach(shiftViewModel.firstEmployees, id: \.self) { employee in
                                ZStack{
                                    Color(.green)
                                    Text(employee.name).foregroundColor(.black)
                                }.tag(employee.uid)
                            }
                            ForEach(shiftViewModel.secondEmployees, id: \.self) { employee in
                                ZStack{
                                    Color(.orange)
                                    Text(employee.name).foregroundColor(.black)
                                }.tag(employee.uid)
                            }
                            ForEach(shiftViewModel.thirdEmployees, id: \.self) { employee in
                                ZStack{
                                    Color(.red)
                                    Text(employee.name).foregroundColor(.black)
                                }.tag(employee.uid)
                            }
                            ForEach(shiftViewModel.fourthEmployees, id: \.self) { employee in
                                ZStack{
                                    Color(.gray)
                                    Text(employee.name).foregroundColor(.black)
                                }.tag(employee.uid)
                            }
                        }
                        Picker(selection: $selectedTeam, label: Text("🏆 Team:").foregroundColor(.black)) {
                            ForEach(K.FStore.Employees.roles, id: \.self) { role in
                                Text(role).foregroundColor(.black).tag(role)
                            }
                        }
                        Toggle(isOn: $upForGrabsField) {
                            Text("⚫️ Up for grabs:")
                        }
                        .foregroundColor(.black)
                        if !self.$usingPreset.wrappedValue {
                            DatePicker("🗓 Start date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .foregroundColor(.black)
                                .onChange(of: startDate, perform: { value in
                                    shiftViewModel.loadDisposition(date: value)
                                    presetDate = startDate
                                })
                            DatePicker("🗓 End date", selection: $endDate, in: startDate... , displayedComponents: [.date, .hourAndMinute])
                                .foregroundColor(.black)
                                .onChange(of: endDate, perform: { value in
                                    shiftViewModel.loadDisposition(date: value)
                                })
                        } else {
                            DatePicker("🗓 Select date", selection: $presetDate, displayedComponents: [.date])
                                .foregroundColor(.black)
                                .onChange(of: presetDate, perform: { value in
                                    shiftViewModel.loadDisposition(date: value)
                                })
                        }
                    } else { // Normal view
                        Text("📌 Assigned employee: \(selectedEmployeeName)")
                            .foregroundColor(.black)
                        Text("🏆 Team: \(selectedTeamName)")
                            .foregroundColor(.black)
                        Text("⚫️ Up for grabs: \(shiftViewModel.shift?.upForGrabs.description ?? "false")")
                            .foregroundColor(.black)
                        Text("🗓 Start date:\n\n\(shiftViewModel.shift!.getStartDateFormatted())\n")
                            .foregroundColor(.black)
                        Text("🗓 End date:\n\n\(shiftViewModel.shift!.getEndDateFormatted())\n")
                            .foregroundColor(.black)
                    }
                } header: {
                    Text("Shift info")
                }
                Section {
                    if self.$shiftViewModel.canEdit.wrappedValue { // Admin view
                        if self.$shiftViewModel.edit.wrappedValue {
                            Button {
                                if usingPreset {
                                    let result = shiftViewModel.usePreset(currentDate: startDate, selectedPreset: selectedPreset)
                                    self.startDate = result[0]
                                    self.endDate = result[1]
                                }
                                shiftViewModel.shift = Shift(employee: selectedEmployee, endDate: Timestamp(date: endDate) , role: selectedTeam, startDate: Timestamp(date: startDate), upForGrabs: upForGrabsField, FSID: shiftViewModel.shift!.FSID)
                                calendarViewModel.saveShift(shiftViewModel.shift!)
                                shiftViewModel.editShift()
                            } label: {
                                Text("💾 Save changes")
                                    .foregroundColor(.black)
                            }
                        } else {
                            if currentUser.role == K.FStore.Employees.roles[0] || currentUser.role == K.FStore.Employees.roles[0] {
                                Button {
                                    shiftViewModel.editShift()
                                } label: {
                                    Text("✏️ Edit shift")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        if shiftViewModel.shift?.FSID != "" {
                            Button {
                                calendarViewModel.deleteShift(shiftViewModel.shift!)
                                alreadySeen = false
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("❌ Delete shift")
                                    .foregroundColor(.black)
                            }
                        }
                    } else { // User view
                        Button {
                            
                        } label: {
                            Text("✅ Ready for the next stage")
                                .foregroundColor(.black)
                        }
                    }
                } header: {
                    Text("Actions")
                }
            }.foregroundColor(.white)
                .background(.black)
                .onAppear {
                    if !alreadySeen {
                        upForGrabsField = shiftViewModel.shift!.upForGrabs
                        endDate = shiftViewModel.shift!.endDate.dateValue()
                        startDate = shiftViewModel.shift!.startDate.dateValue()
                        shiftViewModel.updateFields { result in
                            selectedEmployeeName = result[0]!
                            selectedEmployee = result[0]!
                            selectedTeam = result[1]!
                            selectedTeamName = result[1]!
                        }
                        shiftViewModel.loadPresets(currentDate: startDate)
                        shiftViewModel.loadDisposition(date: startDate)
                        selectedEmployee = shiftViewModel.employees.first!.name
                    }
                    alreadySeen = true
                }
                
        }
    }
}
