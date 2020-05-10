//
//  HomeVC.swift
//  Netflux
//
//  Created by Martin Parker on 07/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher

class HomeVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var headerImg: UIImageView!
    @IBOutlet weak var collectionView1: UICollectionView! // For Now Playing
    
    @IBOutlet weak var collectionView3: UICollectionView! // Popular on Netflux
    @IBOutlet weak var collectionView4: UICollectionView! // Top Rated
    @IBOutlet weak var collectionView5: UICollectionView! // For Coming Soon
    
    //Set the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Variable
    var movieNowPlaying = [Movie]()
    var moviePopular    = [Movie]()
    var movieTopRated   = [Movie]()
    var movieComingSoon = [Movie]()
    var selectedMovie   : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide the NavBar
        fetchAllMovieData()
        
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
    }
 
    //Function to fetch all movies at the same function
    func fetchAllMovieData(){
        fetchMovie(for: "now_playing", at: "US")
        fetchMovie(for: "popular", at: "US")
        fetchMovie(for: "top_rated", at: "MY")
        fetchMovie(for: "upcoming", at: "US")
    }
    
    func setupCollectionView(){
        //CollectionView1 - Now Playing
        collectionView1.delegate    = self
        collectionView1.dataSource  = self
        collectionView1.register(UINib(nibName: Identifiers.MovieCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.MovieCell)
        
        //CollectionView3 - Popular on Netflux
        collectionView3.delegate    = self
        collectionView3.dataSource  = self
        collectionView3.register(UINib(nibName: Identifiers.MovieCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.MovieCell)
        
        //CollectionView4 - Top Rated
        collectionView4.delegate    = self
        collectionView4.dataSource  = self
        collectionView4.register(UINib(nibName: Identifiers.MovieCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.MovieCell)
        
        //CollectionView5- Now Playing
        collectionView5.delegate    = self
        collectionView5.dataSource  = self
        collectionView5.register(UINib(nibName: Identifiers.MovieCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.MovieCell)
    }
    //Function to hide the navagation bar
    func configureNavBar(){
        navigationController?.isNavigationBarHidden = true
    }
    
    //Function to fetch movies data
    func fetchMovie(for movietype: String, at place: String){
        NetworkManager.shared.getMovies(type: movietype, region: place) { (moviesResponse, errorMessage) in
            guard let moviesResponse = moviesResponse else{
                print(errorMessage!.rawValue)
                return
            }
            if movietype == "now_playing" {
                self.movieNowPlaying = moviesResponse.results
                DispatchQueue.main.async {
                    self.collectionView1.reloadData()
                    self.UpdateHeaderImg()
                }
            }else if movietype == "popular"{
                self.moviePopular = moviesResponse.results
                DispatchQueue.main.async {
                    self.collectionView3.reloadData()
                }
            }else if movietype == "top_rated"{
                self.movieTopRated = moviesResponse.results
                DispatchQueue.main.async {
                    self.collectionView4.reloadData()
                }
            }else if movietype == "upcoming"{
                self.movieComingSoon = moviesResponse.results
                DispatchQueue.main.async {
                    self.collectionView5.reloadData()
                }
            }
        }
    }
    //Update headerImg with random movie from NowPlaying
    func UpdateHeaderImg(){
        let randomNo = Int.random(in: 0 ... movieNowPlaying.count - 1)
        if let url = URL(string: movieNowPlaying[randomNo].posterURL.absoluteString){
            headerImg.kf.indicatorType = .activity
            headerImg.kf.setImage(with: url)
        }
    }
    
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionView3){
            return moviePopular.count
        }else if (collectionView == collectionView4){
            return movieTopRated.count
        }else if (collectionView == collectionView5){
            return movieComingSoon.count
        }else{
            return movieNowPlaying.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.MovieCell, for: indexPath) as? MovieCell {
            
            if (collectionView == collectionView3) {
                cell.configureCell(movie: moviePopular[indexPath.row])
                return cell
            }else if (collectionView == collectionView4) {
                cell.configureCell(movie: movieTopRated[indexPath.row])
                return cell
            }else if (collectionView == collectionView5) {
                cell.configureCell(movie: movieComingSoon[indexPath.row])
                return cell
            }else{
                cell.configureCell(movie: movieNowPlaying[indexPath.row])
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.frame.height
        let cellHeight = height - 20
        let cellWidth = cellHeight / 1.5
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if (collectionView == collectionView3){
            selectedMovie = moviePopular[indexPath.row]
            performSegue(withIdentifier: Segues.toMovieDetailVC, sender: self)
        }else if (collectionView == collectionView4){
            selectedMovie = movieTopRated[indexPath.row]
            performSegue(withIdentifier: Segues.toMovieDetailVC, sender: self)
        }else if (collectionView == collectionView5){
            selectedMovie = movieComingSoon[indexPath.row]
            performSegue(withIdentifier: Segues.toMovieDetailVC, sender: self)
        }else{
            selectedMovie = movieNowPlaying[indexPath.row]
            performSegue(withIdentifier: Segues.toMovieDetailVC, sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toMovieDetailVC {
            if let destination = segue.destination as? MovieDetailVC{
                destination.movie = selectedMovie
            }
        }
    }
    
}

