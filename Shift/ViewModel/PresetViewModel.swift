//
//  PresetViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 05/01/2022.
//

import Foundation
import Firebase

class PresetViewModel: ObservableObject {
    
    @Published var presets: [Preset] = []
    var preset: Preset = Preset(startDate: Timestamp(date: Date()), endDate: Timestamp(date: Date()), name: "", FSID: "")
    
    func setPresets(_ presets: [Preset]) {
        self.presets = presets
    }
    
    func loadPresets() {
        WebService.shared.loadPresets { result in
            self.presets = result!
        }
    }
    
    func detachPresets() {
        WebService.shared.detachListener(WebService.shared.presetListener)
    }
    
    func addPreset() {
        
    }
    
    func delete(_ preset: Preset) {
        WebService.shared.deletePreset(preset)
    }
    
    func save(_ preset: Preset) {
        WebService.shared.savePreset(preset)
    }
    
}
