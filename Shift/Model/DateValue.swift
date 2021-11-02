//
//  DateValue.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 02/11/2021.
//

import SwiftUI

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
