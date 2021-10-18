//
//  MainView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 13/10/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        CalendarView(interval: .init()) { _ in
                    Text("30")
                        .padding(8)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
