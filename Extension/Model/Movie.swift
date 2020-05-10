//
//  Movie.swift
//  Netflux
//
//  Created by Martin Parker on 07/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

//MARK: Data Model for Movie
struct MoviesResponse: Codable {
    public let page         : Int
    public let totalResults : Int
    public let totalPages   : Int
    public let results      : [Movie]
}

struct Movie: Codable {
    
    public let id           : Int
    public let title        : String
    public let backdropPath : String?
    public let posterPath   : String?
    public let overview     : String?
    public let releaseDate  : Date?
    public let voteAverage  : Double?
    
    //Movie Main Poster URL
    public var posterURL    : URL {
        return URL(string: "https://image.tmdb.org/t/p/w300\(posterPath ?? "")")!
    }
    //Movie Detail Poster URL
    public var backdropURL  : URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
}

//MARK: Data Model for Video
struct MovieVideoResponse: Codable {
    public let results : [MovieVideo]
}

public struct MovieVideo: Codable {
    public let id        : String
    public let key       : String?
    public var youtubeURL: URL {
        return URL(string: "https://www.youtube.com/watch?v=\(key ?? "")")!
    }

}
