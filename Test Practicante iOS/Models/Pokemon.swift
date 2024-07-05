//
//  Pokemon.swift
//  Test Practicante iOS
//
//  Created by Edgar Alexandro Castillo Palacios on 05/07/24.
//

import Foundation

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let height: Int
    let weight: Int
    let sprites: Sprites
    let stats: [Stat]
}
