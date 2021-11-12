//
//  TaskView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 12/11/2021.
//

import Foundation
import SwiftUI

struct TaskView: View {
    
    var body: some View {
        Text("test")
            .foregroundColor(.white)
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color(.black).ignoresSafeArea()
            TaskView()
        }
    }
}
