//
//  DataModel.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import Foundation

enum DataType {
    case teams
    case players(teamId: Int)
    case image(id: Int)
    
    var title: String {
        switch self {
        case .teams:
            "Teams"
        case .players:
            "Players"
        case .image:
            "Image"
        }
    }
    
    var decodableType: Decodable.Type {
        switch self {
        case .teams:
            CricketTeamsResponse.self
        case .players:
            CricketPlayersResponse.self
        case .image:
            Data.self
        }
    }
}

struct CricketTeamsResponse: Codable {
    let list: [TeamData]
    let appIndex: AppIndex
}

struct CricketPlayersResponse: Codable {
    let player: [PlayerData]
}

struct AppIndex: Codable {
    let seoTitle: String
    let webURL: String
}

struct TeamData: Codable {
    var teamId: Int?
    var teamName: String
    var teamSName: String?
    var imageId: Int?
    var countryName: String?
}

struct PlayerData: Codable {
    var id: String?
    var name: String
    var imageId: Int
    var battingStyle: String?
    var bowlingStyle: String?
}
