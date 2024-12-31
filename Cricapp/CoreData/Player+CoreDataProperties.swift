//
//  Player+CoreDataProperties.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//
//

import Foundation
import CoreData

extension Player {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var name: String?
    @NSManaged public var playerId: NSDecimalNumber?
    @NSManaged public var imageId: NSDecimalNumber
    @NSManaged public var battingStyle: String?
    @NSManaged public var bowlingStyle: String?
    @NSManaged public var image: Data?
    @NSManaged public var fromTeam: Team?
}

extension Player: Identifiable {
    private static func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
    
    class func deleteAll(_ context: NSManagedObjectContext, forId id: Int? = nil) {
        // This will only delete on persistent store not in Memory context
        let request = Player.request()
        if let id {
            Team.getTeam(for: id, in: context) { team in
                if let team {
                    request.predicate = NSPredicate(format: "fromTeam == %@", team)
                }
            }
        } else {
            request.predicate = NSPredicate(value: true)
        }
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { return }
            try persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    class func deleteAll(in context: NSManagedObjectContext, forId id: Int? = nil) {
        let request = Player.request()
        if let id {
            Team.getTeam(for: id, in: context) { team in
                if let team {
                    request.predicate = NSPredicate(format: "fromTeam == %@", team)
                }
            }
        } else {
            request.predicate = NSPredicate(value: true)
        }
        let teams = try? context.fetch(request) as? [Player]
        teams?.forEach({ team in
            context.delete(team)
        })
        DispatchQueue.main.async {
            save(context)
        }
    }
    
    static func createData(with data: [PlayerData], forTeamId teamId: Int, in context: NSManagedObjectContext) async {
        var team: Team?
        Team.getTeam(for: teamId, in: context) { fetchedTeam in
            team = fetchedTeam
        }
        var players = [Player]()
        for playerData in data {
            if playerData.id != nil {
                let player = Player(context: context)
                player.playerId = NSDecimalNumber(string: playerData.id)
                player.name = playerData.name
                player.imageId = NSDecimalNumber(value: playerData.imageId)
                player.battingStyle =  playerData.battingStyle
                player.bowlingStyle = playerData.bowlingStyle
                player.fromTeam = team
                do {
                    player.image = try await URLSessionManager.shared.getImage(id: Int(truncating: player.imageId))
                } catch {
                    AppLogger.shared.error("Failed to fetch image for id: \(player.imageId) \(error.localizedDescription)")
                }
                players.append(player)
            }
        }
        
        team?.toPlayer = NSSet(array: players)
        DispatchQueue.main.async {
            save(context)
        }
    }
    
    static func save(_ context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
