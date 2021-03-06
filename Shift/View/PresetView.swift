//
//  PresetView.swift
//  Shift
//
//  Created by Piotr ฤwiertnia on 05/01/2022.
//

import Foundation
import SwiftUI
import Firebase

struct PresetView: View {
    
    @StateObject var presetViewModel = PresetViewModel()
    @State var startTime: Date = Date()
    @State var endTime: Date = Date()
    @State var nameField: String = ""
    
    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
            Form {
                Section {
                    Text("๐ Name new preset:")
                    TextField("Preset name...", text: $nameField)
                    DatePicker("๐ Start time", selection: $startTime, displayedComponents: [.hourAndMinute])
                    DatePicker("๐ End time", selection: $endTime, in: startTime..., displayedComponents: [.hourAndMinute])
                    Button {
                        presetViewModel.save(Preset(startDate: Timestamp(date: startTime), endDate: Timestamp(date: endTime), name: nameField, FSID: ""))
                    } label: {
                        Text("๐พ Save changes")
                    }
                }
                Section {
                    ScrollView {
                            ForEach(presetViewModel.presets, id: \.self) { value in
                                PresetCard(value: value)
                            }
                    }
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
                Text("From \(value!.getStartDateTime()[0]):\(value!.getStartDateTime()[1]) to \(value!.getEndDateTime()[0]):\(value!.getEndDateTime()[1])")
                Button {
                    presetViewModel.delete(value!)
                } label: {
                    Text("๐ Delete")
                }
                Color.gray.frame(height:CGFloat(1) / UIScreen.main.scale)
            }
        }
    }
}
