//
//  MADatabaseHandler.swift
//  MovieApp
//
//  Created by Chandan Singh on 22/04/21.
//  Copyright © 2021 Personal. All rights reserved.
//

import Foundation
import UIKit
import CoreData

final class MADatabaseHandler {
    
    private lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "MovieData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    private func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveData() -> [Movie]? {
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        let result = try? managedContext.fetch(fetchRequest)
        if result != nil {
            let movies = Movie.initializeMovieItems(managedObjects: result as! [MoviesData])
            return movies
        }
        return nil
    }
    
    func retrieveAndStoreData(movieData: [Movie]) {
        
        let managedContext = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        
        for movie in movieData {
            fetchRequest.predicate = NSPredicate(format: "movieId = %d", movie.id)
            do {
                let result = try managedContext.fetch(fetchRequest)
                if result.count != 0 {
                    //Update
                    self.updateData(movie: movie)
                } else {
                    //Create
                    self.createData(movie: movie)
                }
            } catch {
                
            }
        }
    }
    
    func createData(movie: Movie) {
        
        let managedContext = self.persistentContainer.viewContext
        let movieEntity = NSEntityDescription.entity(forEntityName: "MoviesData", in: managedContext)!
        
        let movieData = NSManagedObject(entity: movieEntity, insertInto: managedContext)
        movieData.setValue(movie.isAdult, forKey: "isAdult")
        movieData.setValue(false, forKey: "isFavorite")
        movieData.setValue(Int64(movie.id), forKey: "movieId")
        movieData.setValue(movie.title, forKey: "movieTitile")
        movieData.setValue(movie.overview, forKey: "overview")
        movieData.setValue(movie.posterPath, forKey: "posterPath")
        movieData.setValue(movie.rating, forKey: "rating")
        movieData.setValue(movie.releaseDate, forKey: "releaseDate")
        movieData.setValue(Int64(movie.voteCount), forKey: "voteCount")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateData(movie: Movie) {
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MoviesData")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", movie.id)
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            let movieData = result[0] as! NSManagedObject
            movieData.setValue(movie.isAdult, forKey: "isAdult")
            movieData.setValue(false, forKey: "isFavorite")
            movieData.setValue(Int64(movie.id), forKey: "movieId")
            movieData.setValue(movie.title, forKey: "movieTitile")
            movieData.setValue(movie.overview, forKey: "overview")
            movieData.setValue(movie.posterPath, forKey: "posterPath")
            movieData.setValue(movie.rating, forKey: "rating")
            movieData.setValue(movie.releaseDate, forKey: "releaseDate")
            movieData.setValue(Int64(movie.voteCount), forKey: "voteCount")
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    func updateFavorite(movieId: Int64, isFavorite: Bool) {
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "MoviesData")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", movieId)
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            let movieData = result[0] as! NSManagedObject
            movieData.setValue(isFavorite, forKey: "isFavorite")
            
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
        }
        catch {
            print(error)
        }
    }
    
    func deleteData(movieId: Int64){
        
        let managedContext = self.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MoviesData")
        fetchRequest.predicate = NSPredicate(format: "movieId = %d", movieId)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = result[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            }
            catch {
                print(error)
            }
            
        }
        catch {
            print(error)
        }
    }
}
