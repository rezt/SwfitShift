//
//  DispositionViewModel.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation
import Firebase

final class DispositionViewModel: ObservableObject {
    
    let db = Firestore.firestore()
    
    @Published var thisMonth: [Disposition] = []
}
