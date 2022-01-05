//
//  PresetView.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation
import SwiftUI


struct PresetView: View {
    
    @StateObject var presetViewModel = PresetViewModel()
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            ScrollView {
                ForEach(presetViewModel.presets, id: \.self) { value in
                    PresetCard(value: value)
                }
            }
        }.onAppear {
            presetViewModel.loadPresets()
        }
        .onDisappear {
            presetViewModel.detachPresets()
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
