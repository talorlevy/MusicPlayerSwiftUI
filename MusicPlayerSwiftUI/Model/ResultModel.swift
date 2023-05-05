//
//  ResultModel.swift
//  MusicPlayerSwiftUI
//
//  Created by Talor Levy on 3/25/23.
//

import Foundation


struct ResultModel: Codable {
    var trackId: Int
    var artistName: String?
    var trackName: String?
    var releaseDate: String?
    var trackPrice: Double?
    var previewUrl: String?
    var artworkUrl100: String?
}
