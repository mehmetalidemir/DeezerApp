//
//  Artist.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import Foundation

struct Artist: Codable {
    let id: Int?
    let link, name, share, picture: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let nb_album, nb_fan: Int?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}

struct GenreArtists: Codable {
    let data: [GenreArtist]?
}

struct GenreArtist: Codable {
    let id: Int?
    let picture, name: String?
    let picture_small, picture_medium, picture_big, picture_xl: String?
    let radio: Bool?
    let tracklist: String?
    let type: String?
}
