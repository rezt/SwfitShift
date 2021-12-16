//
//  Disposition.swift
//  Shift
//
//  Created by Piotr Ćwiertnia on 16/12/2021.
//

import Foundation

struct Disposition: Hashable {
    let available: [String]
    let notPreferred: [String]
    let unavailable: [String]
    let unknown: [String]
}
