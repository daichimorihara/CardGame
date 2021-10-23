//
//  Theme.swift
//  CardGame
//
//  Created by Daichi Morihara on 2021/10/23.
//

import Foundation

struct Theme: Identifiable, Codable, Hashable {
    var name: String
    var emojis: String
    var numbers: Int
    var color: String
    var id: Int
}
