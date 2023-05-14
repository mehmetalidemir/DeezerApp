<p align="center">
  <a href="https://github.com/mehmetalidemir/FoodOrderApp">
    <img src="https://i.imgur.com/flF38Qe.png" alt="Logo" width="100" height="100">
  </a>
  <h3 align="center">Deezer App</h3>
  </p>
</p>

DeezerApp is a mobile application developed using Swift and UIKit. The app is designed following MVVM architectural pattern to provide users with the ability to browse music categories and artists and access detailed information about them. The app uses a RESTful API to retrieve data about categories, artists, and albums.

## Features
- Users can view music categories and artists.
- Users can view albums and playlists.
- Users can access detailed information about artists and albums.
- The app retrieves data using the Deezer RESTful API.
- The app allows users to search among their data.

## Video

https://github.com/mehmetalidemir/DeezerApp/assets/64283995/047b0fbf-fcaf-4a0a-a3ea-6f898e07c9e7

## Installation
- Clone this project: git clone https://github.com/mehmetalidemir/DeezerApp.git
- Open the terminal and navigate to the project directory: cd DeezerApp
- Install the required pods: pod install
- Open the Deezer App.xcworkspace file in Xcode.
- Press Command + R to run the application.

## Usage
When you open the application, you will be directed to the home page. The home page will display a list of categories and artists. To navigate between categories and artists, click on the items in the list. To access the album page, click on the artists, and for the list of songs, click on the albums. 

## Technologies
- Swift
- UIKit
- Model-View-ViewModel architectural pattern
- RESTful API
- Kingfisher (SPM)
- AVFoundation (for audio player)

## Pages
### Categories Page
The Music Categories page lists the main music genres, and users can select their preferred genre by choosing a category.

### Artist Listing Page
This page lists the artists in the selected category. Users can click on an artist to navigate to their detail page.

### Album Page
This page displays detailed information about the selected artist, including their albums. Users can click on an album to navigate to its detail page.

### Album Detail Page
This page lists the songs of the selected album. Users can listen to a 30-second preview of a song by clicking on it, and they can also add their favorite songs to the "Favorites" list.

### Favorites Page
The Favorites page displays a list of the user's favorite songs. Users can click on a song in the list to navigate to its album detail page.

## API Endpoint
The endpoint for the Deezer API used in this project is: https://api.deezer.com/
