//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    @State var currentDate: Date = Date()
    @Binding var userID: String
    
    var body: some View {
        
        ZStack{
            Color(.black).ignoresSafeArea()
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    // Calendar View
                    CalendarView(currentDate: $currentDate, userID: userID)
                }
            }
        }.navigationBarHidden(true)
        
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView(userID: "2zJYeIs23RG9ErizhlFY")
//    }
//}
