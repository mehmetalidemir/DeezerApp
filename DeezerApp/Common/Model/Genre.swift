//
//  Genre.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import Foundation

struct Genres: Codable {
    let data: [Genre]?
}

struct Genre: Codable {
    let id: Int?
    let picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let type: String?
}
