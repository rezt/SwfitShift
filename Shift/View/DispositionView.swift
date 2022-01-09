//
//  DispositionView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import SwiftUI

struct DispositionView: View {
    
    @StateObject var dispositionViewModel = DispositionViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                VStack {
                    if self.$dispositionViewModel.isManager.wrappedValue {
                        Button {
                            dispositionViewModel.generateDisposition()
                        } label: {
                            Text("Generate next 31 days...").foregroundColor(.white)
                        }
                        Button {
                            dispositionViewModel.cleanup()
                        } label: {
                            Text("Clean-up disposition")
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
                    ForEach(dispositionViewModel.userDisposition, id: \.self) { value in
                        dayCard(index: dispositionViewModel.userDisposition.firstIndex(of: value)! )
                    }
                }
            }
        }
        .onAppear(perform: {
            dispositionViewModel.loadEmployees()
            dispositionViewModel.loadDisposition()
        })
        .onDisappear(perform: {
            dispositionViewModel.detachEmployees()
            dispositionViewModel.detachDispostion()
        })
    }
    
    @ViewBuilder
    func dayCard(index: Int) -> some View {
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
                .frame(minWidth: 88)
                .foregroundColor(.white)
        }.padding()
    }
    
}
