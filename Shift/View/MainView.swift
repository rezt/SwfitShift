//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    
    @State var currentDate: Date = Date()
    
    var body: some View {

        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Calendar View
                CalendarView(currentDate: $currentDate)
            }
        }
        
        Spacer()
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
