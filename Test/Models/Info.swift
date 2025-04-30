//
//  Info.swift
//  Test
//
//  Created by vaskov on 29.04.2025.
//

import Foundation


struct Response<T: Decodable>: Decodable {
    var info: Info
    var results: [T]
}

struct Info: Decodable {
    var count: Int
    var pages: Int
    var next: String?
    var prev: String?
}

struct Char: Decodable {
    var id: Int
    var name: String?
    var created: String?
    var gender: String?
    var image: String?
}
