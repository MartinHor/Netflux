//
//  MovieDetailVC.swift
//  Netflux
//
//  Created by Martin Parker on 08/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit
import Kingfisher
import WebKit

class MovieDetailVC: UIViewController {
    
    //Outlet
    @IBOutlet weak var movieDetailImg: UIImageView!
    @IBOutlet weak var movieTitleLbl: UILabel!
    @IBOutlet weak var releaseDateLbl: UILabel!
    @IBOutlet weak var overviewTxtView: UITextView!
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var playTrailerBtn: RoundedButton!
    
    //Set the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Variable
    var movie      : Movie!
    var movieUrl   : URL?
    let invalidUrl : String = "https://image.tmdb.org/t/p/w500"
    var videoArray = [MovieVideo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavBarButton()
        updateUI()
        fetchVideoData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        configureNavBar()
        configurePlayButton()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        // Restore the navigation bar to default
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
      
    }
    
    
    @IBAction func playTrailerBtnPressed(_ sender: UIButton) {
        if videoArray.isEmpty == true{
            // print("This Video has no Video.")
            simpleAlert(title: "Oops!", msg: "This Video has no trailer yet.")
            
        }else{
            playTrailerBtn.setTitle("Loading...", for: .normal)
            sender.loadingState()
            let videoURL = videoArray[0].youtubeURL
            let requestObj = URLRequest(url: videoURL as URL)
            DispatchQueue.main.async {
                
                self.webView.load(requestObj)
                
            }
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                self.playTrailerBtn.setTitle("▶ Play Trailer", for: .normal)
            }
        }
    }
    
    //Configure Navigation bar
    func configureNavBar(){
        self.navigationController?.isNavigationBarHidden = false
        // Make the navigation bar background clear
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    //Configure Nav Bar back button
    func configureNavBarButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "custom_backBtn"), style: .plain, target: self, action: #selector(back(sender:)))
    }
    func configurePlayButton(){
        if movie.id == 572299 {
            DispatchQueue.main.async {
                self.playTrailerBtn.setTitle("No Trailer", for: .normal)
                self.playTrailerBtn.isEnabled = false
            }
        }else{
            DispatchQueue.main.async {
                self.playTrailerBtn.setTitle("▶ Play Trailer", for: .normal)
                self.playTrailerBtn.isEnabled = true
            }
        }
        
    }
    
    //Function for back button
    @objc func back(sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated:true)
    }
    
    //Function to update UI component
    func updateUI(){
        guard let url = URL(string: movie.backdropURL.absoluteString) else { return }
        guard let movieDate = movie.releaseDate else { return }
        
        movieUrl                 = url
        let formatter2           = DateFormatter()
        formatter2.locale        = Locale(identifier: "en_US_POSIX")
        formatter2.dateFormat    = "d MMM yyyy"
        let formattedTimeZoneStr = formatter2.string(from: movieDate)
        //dateTxt.text = formattedTimeZoneStr
        //print(formattedTimeZoneStr)
        if  "\(url)" == invalidUrl {
            movieUrl = URL(string: movie.posterURL.absoluteString)
        }
        DispatchQueue.main.async {
            //Load Image
            self.movieDetailImg.kf.indicatorType = .activity
            self.movieDetailImg.kf.setImage(with: self.movieUrl)
            //Load Title
            self.movieTitleLbl.text     = self.movie.title
            //Load Date
            self.releaseDateLbl.text    = formattedTimeZoneStr
            //Load Overview Description
            self.overviewTxtView.text   = self.movie.overview
            self.playTrailerBtn.setTitle("▶ Play Trailer", for: .normal)
            self.playTrailerBtn.isEnabled = true
        }
    }
    //Function to fetch video data
    func fetchVideoData(){
        NetworkManager.shared.getVideo(id: movie.id) { (videosResponse, errorMessage) in
            guard let videosResponse = videosResponse else{
                print(errorMessage!.rawValue)
                return
            }
            self.videoArray = videosResponse.results
            
        }
    }
    
}
