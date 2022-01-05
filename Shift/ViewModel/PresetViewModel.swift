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
    
    func loadPresets() {
        WebService.shared.loadPresets { result in
            self.presets = result!
        }
    }
    
    func addPreset() {
        
    }
    
    func detachPresets() {
        WebService.shared.detachListner(WebService.shared.presetListner)
    }
}
