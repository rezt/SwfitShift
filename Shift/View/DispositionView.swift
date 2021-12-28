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
    @Environment(\.presentationMode) var presentationMode
    
    init(dispositionViewModel: DispositionViewModel, loginViewModel: LoginViewModel) {
        self.dispositionViewModel = dispositionViewModel
        self.auth = loginViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                VStack {
                    if self.$dispositionViewModel.isManager.wrappedValue {
                        Button {
                            dispositionViewModel.generateDisposition()
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Generate next 31 days...")
                        }
                        
                    }
                    HStack {
                        Text("✅")
                            .frame(maxWidth: .infinity)
                        Text("⭕️")
                            .frame(maxWidth: .infinity)
                        Text("❌")
                            .frame(maxWidth: .infinity)
                        Text("❔")
                            .frame(maxWidth: .infinity)
                        Text("")
                            .frame(minWidth: 88)
                    }.padding()
                    ForEach(0 ..< dispositionViewModel.userDisposition.count) { value in
                        dayView(index: value)
                    }
                }
            }
        }
        
        
        
        
    }
    
    @ViewBuilder
    func dayView(index: Int) -> some View {
        HStack {
            Toggle(isOn: Binding(get: {
                return dispositionViewModel.userDisposition[index].value[0]
            }, set: { newValue in
                dispositionViewModel.userDisposition[index].value = [true,false,false,false]
                dispositionViewModel.modifyDisposition(dispositionViewModel.userDisposition[index])
            })) {
            }
            Toggle(isOn: Binding(get: {
                return dispositionViewModel.userDisposition[index].value[1]
            }, set: { newValue in
                dispositionViewModel.userDisposition[index].value = [false,true,false,false]
                dispositionViewModel.modifyDisposition(dispositionViewModel.userDisposition[index])
            })) {
            }
            Toggle(isOn: Binding(get: {
                return dispositionViewModel.userDisposition[index].value[2]
            }, set: { newValue in
                dispositionViewModel.userDisposition[index].value = [false,false,true,false]
                dispositionViewModel.modifyDisposition(dispositionViewModel.userDisposition[index])
            })) {
            }
            Toggle(isOn: Binding(get: {
                return dispositionViewModel.userDisposition[index].value[3]
            }, set: { newValue in
                dispositionViewModel.userDisposition[index].value = [false,false,false,true]
                dispositionViewModel.modifyDisposition(dispositionViewModel.userDisposition[index])
            })) {
            }
            Text(dispositionViewModel.getDate(from: dispositionViewModel.userDisposition[index].date))
                .frame(minWidth: 85)
                .foregroundColor(.white)
        }.padding()
        
        
    }
    
}
