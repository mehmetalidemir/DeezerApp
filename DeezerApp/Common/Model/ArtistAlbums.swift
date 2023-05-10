//
//  ArtistAlbums.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 9.05.2023.
//

import Foundation

struct ArtistAlbums: Codable {
    let data: [ArtistAlbum]?
    let total: Int?
    let next: String?
}

struct ArtistAlbum: Codable {
    let id: Int?
    let link, cover, title: String?
    let cover_small, cover_medium, cover_big, cover_xl: String?
    let md5_image: String?
    let genre_id, fans: Int?
    let release_date: String?
    let record_type: String?
    let tracklist: String?
    let explicit_lyrics: Bool?
    let type: String?
}
