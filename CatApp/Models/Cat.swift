//
//  File.swift
//  CatApp
//
//  Created by Lucas Cardinali on 7/10/24.
//

import Foundation

struct Cat: Identifiable, Decodable, Equatable {
    let id: Int
    let name: String
}
