//
//  AlbumSongs.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 10.05.2023.
//

import Foundation

struct AlbumSongs: Codable {
    let data: [AlbumSong]?
    let total: Int?
}

struct AlbumSong: Codable {
    let id: Int?
    let readable: Bool?
    let title, title_short, title_version, isrc: String?
    let link: String?
    let duration: Int?
    let track_position, disk_number: Int?
    let rank: Int?
    let explicit_lyrics: Bool?
    let explicit_content_lyrics, explicit_content_cover: Int?
    let preview: String?
    let md5_image: String?
    let artist: AlbumSongArtist?
    let type: String?
}

struct AlbumSongArtist: Codable {
    let id: Int?
    let name: String?
    let tracklist: String?
    let type: String?
}
