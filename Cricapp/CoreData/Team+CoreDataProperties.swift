//
//  Team+CoreDataProperties.swift
//  Cricapp
//
//  Created by Shankeerthan on 2024-11-08.
//
//

import Foundation
import CoreData


extension Team {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Team> {
        return NSFetchRequest<Team>(entityName: "Team")
    }

    @NSManaged public var teamName: String?
    @NSManaged public var teamId: NSDecimalNumber?
    @NSManaged public var teamSName: String?
    @NSManaged public var imageId: NSDecimalNumber
    @NSManaged public var countryName: String?
    @NSManaged public var image: Data?
    @NSManaged public var toPlayer: NSSet?
}

// MARK: Generated accessors for toPlayer
extension Team {

    @objc(addToPlayerObject:)
    @NSManaged public func addToToPlayer(_ value: Player)

    @objc(removeToPlayerObject:)
    @NSManaged public func removeFromToPlayer(_ value: Player)

    @objc(addToPlayer:)
    @NSManaged public func addToToPlayer(_ values: NSSet)

    @objc(removeToPlayer:)
    @NSManaged public func removeFromToPlayer(_ values: NSSet)

}

extension Team: Identifiable {
    private static func request() -> NSFetchRequest<NSFetchRequestResult> {
        let request: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: String(describing: Self.self))
        request.returnsDistinctResults = true
        request.returnsObjectsAsFaults = true
        return request
    }
    
    static func isEmpty(_ context: NSManagedObjectContext) -> Bool {
        let request = Team.request()
        do {
            guard let results = try context.fetch(request) as? [Team] else { return true }
            return results.isEmpty
        } catch {
            
        }
        return true
    }
    
    class func deleteAll(_ context: NSManagedObjectContext) {
        // This will only delete on persistent store not in Memory context
        let request = Team.request()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            guard let persistentStoreCoordinator = context.persistentStoreCoordinator else { return }
            try persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            AppLogger.shared.debug("Failed to delete teams data \(error.localizedDescription)")
        }
    }
    
    class func deleteAll(in context: NSManagedObjectContext) {
        let request = Team.request()
        let teams = try? context.fetch(request) as? [Team]
        teams?.forEach({ team in
            context.delete(team)
        })
        DispatchQueue.main.async {
            save(context)
        }
    }
    
    static func createData(with data: [TeamData], _ context: NSManagedObjectContext) async {
        for teamData in data {
            if teamData.teamId != nil {
                let team = Team(context: context)
                team.teamId = NSDecimalNumber(value: teamData.teamId!)
                team.teamName = teamData.teamName
                team.teamSName = teamData.teamSName
                team.imageId =  NSDecimalNumber(value: teamData.imageId ?? 0)
                team.countryName = teamData.countryName
                do {
                    team.image = try await URLSessionManager.shared.getImage(id: Int(truncating: team.imageId))
                } catch {
                    AppLogger.shared.error("Failed to fetch image for id: \(team.imageId) \(error.localizedDescription)")
                }
            }
        }
        await MainActor.run {
            save(context)
        }
    }
    
    static func getTeam(for teamId: Int, in context: NSManagedObjectContext, completion: @escaping (Team?) -> Void) {
        let request = Team.request()
        request.predicate = NSPredicate(format: "teamId == %@", NSDecimalNumber(value: teamId))
        context.performAndWait {
            do {
                guard let results = try context.fetch(request) as? [Team], !results.isEmpty else { return}
                completion(results.first)
            } catch {
                AppLogger.shared.error("Failed to fetch team for id: \(teamId) \(error.localizedDescription)")
                completion(nil)
            }
        }
        return
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
