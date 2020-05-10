//
//  NetworkManager.swift
//  Netflux
//
//  Created by Martin Parker on 07/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

class NetworkManager{
    static let shared   = NetworkManager()
    private let baseURL = "https://api.themoviedb.org/3/movie/"
    private let searchBaseURL = "https://api.themoviedb.org/3/search/movie?api_key="
    private let apiKey  = "ee87cab7979a0ce8ddbb9cae4060b551"
    private init() {}
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder                    = JSONDecoder()
        jsonDecoder.keyDecodingStrategy    = .convertFromSnakeCase
        let dateFormatter                  = DateFormatter()
        dateFormatter.dateFormat           = "yyyy-MM-dd"
        jsonDecoder.dateDecodingStrategy   = .formatted(dateFormatter)
        return jsonDecoder
    }()
    //MARK: Fetch MoviesResponse
    func getMovies(type: String,region: String,completed: @escaping (MoviesResponse?, ErrorMessage?)-> Void) {
        let endPoint = baseURL + "\(type)?api_key=\(apiKey)&region=\(region)"
        
        guard let url = URL(string: endPoint) else{
            completed(nil, .invalidURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let _ = error {
                completed(nil, .unableToComplete)
            }
            
            //create a new variable name based on this response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else{
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let movies = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                completed(movies, nil)
                
            }  catch {
                completed(nil, .invalidDataCatchBlock)
            }
        }
        //Start the network call
        task.resume()
    }
    
    //MARK: Fetch MovieVideoResponse
    func getVideo(id: Int,completed: @escaping (MovieVideoResponse?, ErrorMessage?)-> Void) {
        let endPoint = baseURL + "\(id)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: endPoint) else{
            completed(nil, .invalidURL)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response2, error) in
            
            if let _ = error {
                completed(nil, .unableToComplete)
            }
            
            //create a new variable name based on this response
            guard let response2 = response2 as? HTTPURLResponse, response2.statusCode == 200 else{
                completed(nil, .invalidResponse)
                return
            }
            
            guard let data = data else{
                completed(nil, .invalidData)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let videos = try self.jsonDecoder.decode(MovieVideoResponse.self, from: data)
                completed(videos, nil)
                
            }  catch {
                completed(nil, .invalidDataCatchBlock)
            }
        }
        //Start the network call
        task.resume()
    }
    //Fetch Movie by name
    func getMoviesByName(name: String,completed: @escaping (MoviesResponse?, ErrorMessage?)-> Void) {
           let endPoint = searchBaseURL + "\(apiKey)&language=en-US&page=1&include_adult=false&query=\(name)"
           
           guard let url = URL(string: endPoint) else{
               completed(nil, .invalidURL)
               return
           }
           
           let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
               
               if let _ = error {
                   completed(nil, .unableToComplete)
               }
               
               //create a new variable name based on this response
               guard let response = response as? HTTPURLResponse, response.statusCode == 200 else{
                   completed(nil, .invalidResponse)
                   return
               }
               
               guard let data = data else{
                   completed(nil, .invalidData)
                   return
               }
               
               do {
                   let decoder = JSONDecoder()
                   decoder.keyDecodingStrategy = .convertFromSnakeCase
                   let movies = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                   completed(movies, nil)
                   
               }  catch {
                   completed(nil, .invalidDataCatchBlock)
               }
           }
           //Start the network call
           task.resume()
       }
    
    
}
