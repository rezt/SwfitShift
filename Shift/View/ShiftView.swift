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
    
    @ObservedObject var auth: LoginViewModel
    @ObservedObject var shiftViewModel: ShiftViewModel
    @ObservedObject var calendarViewModel: CalendarViewModel
//    @State var employeeField: String = "employee"
    @State var selectedEmployee: String = "test"
    @State var selectedEmployeeName: String = ""
    @State var roleField: String = "role"
    @State var upForGrabsField: Bool = false
    @State var endDate: Date = Date()
    @State var startDate: Date = Date()
    @Environment(\.presentationMode) var presentationMode
    
    init(shiftViewModel: ShiftViewModel, calendarViewModel: CalendarViewModel, loginViewModel: LoginViewModel){
        UITableView.appearance().backgroundColor = .clear
        self.auth = loginViewModel
        self.shiftViewModel = shiftViewModel
        self.calendarViewModel = calendarViewModel
    }
    
    var body: some View {
        VStack{
            Form {
                Section {
                    if self.$shiftViewModel.edit.wrappedValue { // Edit view
                        Picker(selection: $selectedEmployee, label: Text("📌 Employee:").foregroundColor(.black)) {
                                ForEach(auth.employees, id: \.self) { employee in
                                    Text(employee.name).foregroundColor(.black).tag(employee.uid)
                                }
                            }
                        Picker(selection: $selectedEmployee, label: Text("🏆 Team:").foregroundColor(.black)) {
                                ForEach(auth.employees, id: \.self) { employee in
                                    Text(employee.name).foregroundColor(.black).tag(employee.uid)
                                }
                            }
                        Text("🏆 Team:")
                            .foregroundColor(.black)
                        TextField("Team...", text: $roleField)
                            .foregroundColor(.black)
                        Toggle(isOn: $upForGrabsField) {
                            Text("⚫️ Up for grabs:")
                        }
                        .foregroundColor(.black)
                        DatePicker(selection: $startDate, label: { Text("🗓 Start date:") })
                            .foregroundColor(.black)
                        DatePicker(selection: $endDate, label: { Text("🗓 End date:") })
                            .foregroundColor(.black)
                    } else { // Normal view
                        Text("📌 Assigned employee: \(selectedEmployeeName)")
                            .foregroundColor(.black)
                        Text("🏆 Team: \(shiftViewModel.shift?.role ?? "team")")
                            .foregroundColor(.black)
                        Text("⚫️ Up for grabs: \(shiftViewModel.shift?.upForGrabs.description ?? "false")")
                            .foregroundColor(.black)
                        Text("🗓 Start date:\n\n\(shiftViewModel.shift?.getStartDate() ?? Date())\n")
                            .foregroundColor(.black)
                        Text("🗓 End date:\n\n\(shiftViewModel.shift?.getEndDate() ?? Date())\n")
                            .foregroundColor(.black)
                    }
                } header: {
                    Text("Task info")
                }
                Section {
                    if self.$shiftViewModel.canEdit.wrappedValue { // Admin view
                        if self.$shiftViewModel.edit.wrappedValue {
                            Button {
                                shiftViewModel.shift = Shift(employee: selectedEmployee, endDate: Timestamp(date: endDate) , role: roleField, startDate: Timestamp(date: startDate), upForGrabs: upForGrabsField, FSID: shiftViewModel.shift!.FSID)
                                calendarViewModel.saveShift(shiftViewModel.shift!)
                                shiftViewModel.editShift()
                            } label: {
                                Text("💾 Save changes")
                                    .foregroundColor(.black)
                            }
                        } else {
                            Button {
                                shiftViewModel.editShift()
                            } label: {
                                Text("✏️ Edit shift")
                                    .foregroundColor(.black)
                            }
                        }
                        Button {
                            calendarViewModel.deleteShift(shiftViewModel.shift!)
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("❌ Delete task")
                                .foregroundColor(.black)
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
                    roleField = shiftViewModel.shift!.role
                    upForGrabsField = shiftViewModel.shift!.upForGrabs
                    endDate = shiftViewModel.shift!.endDate.dateValue()
                    startDate = shiftViewModel.shift!.startDate.dateValue()
                    auth.getDetails(forUserID: shiftViewModel.shift!.employee) { result in
                        selectedEmployeeName = result![0].name
                    }
                }
        }
    }
}


struct ShiftView_Previews: PreviewProvider {
    @StateObject var shiftViewModel = ShiftViewModel(withShift: Shift(employee: "", endDate: Timestamp(date: Date()) , role: "", startDate: Timestamp(date: Date()), upForGrabs: false, FSID: ""), canEdit: false)
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var calendarViewModel = CalendarViewModel()
    static var previews: some View {
        let test = ShiftView_Previews()
        ZStack{
            Color(.black).ignoresSafeArea()
            ShiftView(shiftViewModel: test.shiftViewModel, calendarViewModel: test.calendarViewModel, loginViewModel: test.loginViewModel)
        }
    }
}
