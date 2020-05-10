# Netflux
**Netflux** is an app that shows information about movies using the [TMDB API](https://www.themoviedb.org/documentation/api).

![](https://raw.githubusercontent.com/MartinUcsi/Netflux/master/Screenshot/Screenshot%202020-05-10%20at%207.43.53%20PM.png)

## Installation
- Step 1: git clone https://github.com/MartinUcsi/Netflux.git
- Step 2: Install Xcode 11, open Netflux.xcworkspace.
- Step 2: Change the signing team to your own team
- Step 3: Select the build target to "Netflux", chose device or simulator and run.


## Features
- [X] User can view a list of movies. List of movies include popular, top rated, now playing and upcoming movies. Poster images load asynchronously.
- [X] User can view movie details by tapping on a cell.
- [X] User can view the movie trailer by tapping the play trailer button.
- [X] User can search movies.
- [X] Movie details page contain backdrop image, overview, and other relevant information.
- [x] All images are cached in memory and disk.
- [X] User can login using Gmail or their own Apple ID.

**Library used in app**

- [Kingfisher](https://github.com/onevcat/Kingfisher) 
- [Firebase/Auth](https://github.com/firebase/firebase-ios-sdk) 
- [GoogleSignIn](https://cocoapods.org/pods/GoogleSignIn) 

