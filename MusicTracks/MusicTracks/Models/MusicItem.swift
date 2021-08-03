//
//  Movie.swift
//  
//
//  Created by Khatib Mahad H. on 8/3/21.
//

import Foundation

enum MusicWrapperType: String, Codable {
    case track = "track"
    case audiobook = "audiobook"
    case unknown = "unknown"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        self = MusicWrapperType(rawValue: string) ?? .unknown
    }
}

struct MusicItem: Codable {
    let wrapperType: MusicWrapperType
    let artistName: String
    let primaryGenreName: String
    let trackName: String?
    let trackPrice: Double?
    let releaseDate: Date
}
