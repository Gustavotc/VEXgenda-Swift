<h1 align="center">
  Vexgenda
</h1>

<p align="center">
  <img alt="License" src="https://img.shields.io/static/v1?label=license&message=MIT&color=4895ef&labelColor=0A1033">

##  📱 Preview
![1](https://user-images.githubusercontent.com/65514572/148657199-28b2c0c2-17b3-40f6-bf4a-15a9eb2b3e11.png) ![2](https://user-images.githubusercontent.com/65514572/148657260-a49b902a-bfde-4bef-a149-930a10342595.png) 
![3](https://user-images.githubusercontent.com/65514572/148657349-f689e945-1e62-4005-a0f1-a47d8c124085.png) ![4](https://user-images.githubusercontent.com/65514572/148657364-c72f5d07-83b2-44fa-8784-ca8d96c6fd7b.png)
![5](https://user-images.githubusercontent.com/65514572/148657369-81379955-d2da-4b51-a831-2696951c0df1.png)
![6](https://user-images.githubusercontent.com/65514572/148657373-2768e37c-8bb1-4f09-ba1b-d7ebcc2b79cd.png)
![7](https://user-images.githubusercontent.com/65514572/148657377-5d19fcbb-ffb8-4ac6-9af3-50bf5376992f.png)

## 💻 Project
Custom contacts agenda, offline-first and on MVVM pattern. Integrated with Google contacts via People API.<br>
Create, edit and delete contacts in a fully syncronized way.

 
## :hammer_and_wrench: Features 

-   [ ] Google OAuth2;
-   [ ] Get the Google contacts of the logged user (name, phone numbers, emails and photo);
-   [ ] List user contacts;
-   [ ] Contact search with live suggestion;
-   [ ] Store user contacts in local database (RealmDB);
-   [ ] Offline-first (changes are saved in the local database until synchronized by the API);
-   [ ] Inputs validations with Regex and masks;


## ✨ Technologies

-   [ ] Swift
-   [ ] Google OAuth2.0  
-   [ ] People Api
-   [ ] PromiseKit
-   [ ] Async Storage
-   [ ] RealmDb
-   [ ] Alamofire

## 👨‍💻 Getting Started

Install de project dependencies: 
```shell
pod install
```

Create a project on Google Cloud with OAuth 2.0 and People API access
and make the following changes: 
 
 ```swift
 //PeopleAPI.swift
private let apiKey = "YOUR_API_KEY"
```

 ```swift
//OAuthService.swift
URLQueryItem(name: "client_id", value: "YOUR_CLIENT_ID"),
            URLQueryItem(name: "redirect_uri", value: "YOUR_REDIRECT_URI"),
```

## 📄 License

This project is under MIT license. Check the [LICENSE](LICENSE.md) for more details.

<br />
