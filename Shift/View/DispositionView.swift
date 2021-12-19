//
//  DispositionView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import SwiftUI

struct DispositionView: View {
    
    @ObservedObject var dispositionViewModel: DispositionViewModel
    @ObservedObject var auth: LoginViewModel
    
    init(dispositionViewModel: DispositionViewModel, loginViewModel: LoginViewModel) {
        self.dispositionViewModel = dispositionViewModel
        self.auth = loginViewModel
    }
    
    var body: some View {
        
        VStack {
            ForEach(0 ..< dispositionViewModel.userDisposition.count) { value in
                dayView(index: value)
            }
        }.onAppear {
        }.onDisappear {
            dispositionViewModel.saveDisposition()
        }
        
        
    }
    
    @ViewBuilder
    func dayView(index: Int) -> some View {
        VStack {
            HStack {
                Text("")
                    .frame(minWidth: 85)
                Text("✅")
                    .frame(maxWidth: .infinity)
                Text("⭕️")
                    .frame(maxWidth: .infinity)
                Text("❌")
                    .frame(maxWidth: .infinity)
                Text("❔")
                    .frame(maxWidth: .infinity)
            }.padding()
            HStack {
                Text(dispositionViewModel.getDate(from: dispositionViewModel.userDisposition[index].date))
                    .frame(minWidth: 85)
                Toggle(isOn: Binding(get: {
                    return dispositionViewModel.userDisposition[index].value[0]
                }, set: { newValue in
                    dispositionViewModel.userDisposition[index].value = [true,false,false,false]
                })) {
                }
                Toggle(isOn: Binding(get: {
                    return dispositionViewModel.userDisposition[index].value[1]
                }, set: { newValue in
                    dispositionViewModel.userDisposition[index].value = [false,true,false,false]
                })) {
                }
                Toggle(isOn: Binding(get: {
                    return dispositionViewModel.userDisposition[index].value[2]
                }, set: { newValue in
                    dispositionViewModel.userDisposition[index].value = [false,false,true,false]
                })) {
                }
                Toggle(isOn: Binding(get: {
                    return dispositionViewModel.userDisposition[index].value[3]
                }, set: { newValue in
                    dispositionViewModel.userDisposition[index].value = [false,false,false,true]
                })) {
                }
            }.padding()
        }
        
    }
    
    
}
