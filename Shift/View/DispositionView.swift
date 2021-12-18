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
            Text("test")
        }.onAppear {
            dispositionViewModel.setAuth(with: auth)
            dispositionViewModel.loadDisposition()
        }
        
        
    }
    
    @ViewBuilder
    func dayView(value: Disposition?) -> some View {
        
    }
    
    
}
