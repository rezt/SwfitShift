//
//  PersonalDisposition.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 18/12/2021.
//

import Foundation

struct PersonalDisposition: Identifiable {
    var id = UUID().uuidString
    var date: Date
    var value: [Bool]
}
