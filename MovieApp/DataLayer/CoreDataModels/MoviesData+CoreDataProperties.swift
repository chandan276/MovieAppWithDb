//
//  MoviesData+CoreDataProperties.swift
//  
//
//  Created by Chandan Singh on 20/04/21.
//
//

import Foundation
import CoreData


extension MoviesData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesData> {
        return NSFetchRequest<MoviesData>(entityName: "MoviesData")
    }

    @NSManaged public var movieId: Int64
    @NSManaged public var movieTitile: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var rating: Double
    @NSManaged public var overview: String?
    @NSManaged public var voteCount: Int64
    @NSManaged public var isAdult: Bool
    @NSManaged public var isFavorite: Bool

}
