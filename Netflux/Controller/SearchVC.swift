//
//  SearchVC.swift
//  Netflux
//
//  Created by Martin Parker on 09/05/2020.
//  Copyright © 2020 Martin Parker. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UISearchBarDelegate {
    
    //Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Set the status bar text color to white
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //Variable
    var movies = [Movie]()
    var selectedMovie : Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setUpSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchBar.text = ""
        collectionView.reloadData()
    }
    
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Identifiers.MovieCell, bundle: nil), forCellWithReuseIdentifier: Identifiers.MovieCell)
    }
    
    func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    //Search Bar function
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else{
            movies.removeAll()
            collectionView.reloadData()
            return
        }
        //Start fetching data using searchBar.text
        guard let text = searchBar.text else { return }
        fetchMovie(by: text.lowercased())
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    //Fetch movie function
    func fetchMovie(by text: String){
        NetworkManager.shared.getMoviesByName(name: text) { (moviesResponse, errorMessage) in
            guard let moviesResponse = moviesResponse else{
                print(errorMessage!.rawValue)
                return
            }
            //Fetch Data Success
            self.movies = moviesResponse.results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

}
extension SearchVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.MovieCell, for: indexPath) as? MovieCell {
            
            cell.configureCell(movie: movies[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        let cellWidth = (width - 36) / 3
        let cellHeight = cellWidth * 1.5
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedMovie = movies[indexPath.row]
        performSegue(withIdentifier: Segues.toMovieDetailVC, sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.toMovieDetailVC {
            if let destination = segue.destination as? MovieDetailVC{
                destination.movie = selectedMovie
            }
        }
    }
    
    //To dismiss the keyboard when collectionView is begin scrolling
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
