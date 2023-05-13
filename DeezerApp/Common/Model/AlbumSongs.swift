//
//  AlbumSongs.swift
//  DeezerApp
//
//  Created by Mehmet Ali Demir on 10.05.2023.
//

import Foundation

struct AlbumSongs: Codable {
    var data: [AlbumSong]?
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case data
        case total
    }
}

struct AlbumSong: Codable {
    var id: Int?
    let readable: Bool?
    var title: String?
    let titleShort, titleVersion, isrc: String?
    let link: String?
    var duration, trackPosition, diskNumber, rank: Int?
    let explicitLyrics: Bool?
    let explicitContentLyrics, explicitContentCover: Int?
    let preview: String?
    let md5Image: String?
    var artist: AlbumSongArtist?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case readable
        case title
        case titleShort = "title_short"
        case titleVersion = "title_version"
        case isrc
        case link
        case duration
        case trackPosition = "track_position"
        case diskNumber = "disk_number"
        case rank
        case explicitLyrics = "explicit_lyrics"
        case explicitContentLyrics = "explicit_content_lyrics"
        case explicitContentCover = "explicit_content_cover"
        case preview
        case md5Image = "md5_image"
        case artist
        case type
    }
}

struct AlbumSongArtist: Codable {
    let id: Int?
    let name: String?
    let pictureSmall, pictureMedium, pictureBig, pictureXl: String?
    let tracklist: String?
    let type: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pictureSmall = "picture_small"
        case pictureMedium = "picture_medium"
        case pictureBig = "picture_big"
        case pictureXl = "picture_xl"
        case tracklist
        case type
    }
}
