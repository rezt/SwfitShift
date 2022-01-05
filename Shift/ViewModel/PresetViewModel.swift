//
//  PresetViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation

class PresetViewModel: ObservableObject {
    
    @Published var presets: [Preset] = []
    
    func setPresets(_ presets: [Preset]) {
        self.presets = presets
    }
}
