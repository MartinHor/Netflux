//
//  MovieCell.swift
//  Netflux
//
//  Created by Martin Parker on 08/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {
    
    //Outlet
    @IBOutlet weak var movieCellImg: UIImageView!
    
    //Variable
    var movieUrl : URL?
    let invalidUrl : String = "https://image.tmdb.org/t/p/w300"
    let invalidImageUrl = "https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482930.jpg"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(movie: Movie){
        
        guard let url = URL(string: movie.posterURL.absoluteString) else { return }
        movieUrl = url
        
        if  "\(url)" == invalidUrl {
            movieUrl = URL(string: invalidImageUrl)
        }
        movieCellImg.kf.indicatorType = .activity
        movieCellImg.kf.setImage(with: movieUrl)
    }
}
