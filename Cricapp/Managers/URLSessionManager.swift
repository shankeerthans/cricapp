//
//  URLSessionManager.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//

import Foundation
import CoreData
import UIKit
class URLSessionManager: NSObject {
    struct Static {
        static var instance: URLSessionManager?
    }
    
    class var shared: URLSessionManager {
        if Static.instance == nil {
            Static.instance = URLSessionManager()
        }
        return Static.instance!
    }
    
    func fetch(data type: DataType, needToDelete: Bool = true, in coreDataContext: NSManagedObjectContext) async {
        AppLogger.shared.debug("Fetch team data called")
        do {
            let (data, _) = try await URLSession.shared.data(for: APIModel.getRequest(type), delegate: self)
            let decodedData = try Coder.jsonDecoder.decode(type.decodableType, from: data)
            
            if let teamDataResponse = decodedData as? CricketTeamsResponse {
                if needToDelete {
                    Team.deleteAll(in: coreDataContext)
                }
                await Team.createData(with: teamDataResponse.list, coreDataContext)
            } else if let playerDataResponse = decodedData as? CricketPlayersResponse {
                if case .players(let teamId) = type {
                    if needToDelete {
                        Player.deleteAll(in: coreDataContext, forId: teamId)
                    }
                    await Player.createData(with: playerDataResponse.player, forTeamId: teamId, in: coreDataContext)
                }
            }
        } catch {
            AppLogger.shared.error("Failed to fetch teams data: \(error.localizedDescription)")
        }
   }
    
    func getImage(id: Int) async throws -> Data {
        AppLogger.shared.debug("Fetch image data called")
        let (data, _) = try await URLSession.shared.data(for: APIModel.getRequest(.image(id: id)), delegate: self)
        AppLogger.shared.debug("Image data successfully fetched")
        return data
    }
    
}

extension URLSessionManager: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error {
            AppLogger.shared.error("Failed to fetch data: \(error.localizedDescription)")
        }
    }
}
