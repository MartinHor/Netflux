//
//  ErrorMessage.swift
//  Netflux
//
//  Created by Martin Parker on 07/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import Foundation

//Error message for errorResponse when fetching data from the database
enum ErrorMessage: String,Error {
    
    case invalidURL                 = "This username created an invalid request. Please try again."
    case unableToComplete           = "Unable to complete your request. Please check your internet connection."
    case invalidResponse            = "Invalid response from the server. Please try again."
    case invalidData                = "The data received from the server was invalid. Please try again."
    case invalidDataCatchBlock      = "The data received from the server was invalid. Please try again. From catch block"}

