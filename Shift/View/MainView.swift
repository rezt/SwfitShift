//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    @Binding var userID: String
    @StateObject var calendarViewModel = CalendarViewModel()
    
    var body: some View {
        
        ZStack{
            Color(.black).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Calendar View
                    CalendarView(userID: userID, calendarViewModel: calendarViewModel)
                    TaskView()
                }
            }
        }.navigationBarHidden(true)
        
    }
}

struct MainView_Previews: PreviewProvider {
    @State var userID = "2zJYeIs23RG9ErizhlFY"
    static var previews: some View {
        let test = MainView_Previews()
        MainView(userID: test.$userID)
    }
}
