//
//  ShiftViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 04/12/2021.
//

import Foundation
import Firebase
import SwiftUI

final class ShiftViewModel: ObservableObject {
    @Published var shift: Shift?
    @Published var canEdit: Bool
    @Published var edit: Bool = false
    
    init(withShift newShift: Shift, canEdit flag: Bool) {
        self.shift = newShift
        self.canEdit = flag
    }
    
    func editShift() {
        print(shift)
        edit = !edit
    }
}
