//
//  PresetView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation
import SwiftUI


struct PresetView: View {
    
    @ObservedObject var presetViewModel: PresetViewModel
    
    init(presetViewModel: PresetViewModel) {
        self.presetViewModel = presetViewModel
    }
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                ForEach(DataViewModel.shared.presets, id: \.self) { value in
                    PresetCard(value: value)
                }
            }
        }
    }
    
    @ViewBuilder
    func PresetCard(value: Preset?) -> some View {
        withAnimation {
            VStack {
                Text(value!.name)
                    .foregroundColor(.white)
            }
        }
    }
}
