//
//  OAuthService.swift
//  Agenda
//
//  Created by INDB on 23/06/21.
//

import Foundation
import Alamofire
import AuthenticationServices
import SafariServices

class OAuthService: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    let userData = UserData.shared
    
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared.keyWindow!
    }
    
    func presentASController() {
        guard let url = try? getLoginUrl() else { return }
        
        let authSession = ASWebAuthenticationSession(url: url,
                                                     callbackURLScheme: "",
                                                     completionHandler: startLogin(url:error:))
        
        if #available(iOS 13.0, *) {
            authSession.presentationContextProvider = self
            authSession.prefersEphemeralWebBrowserSession = true
        }
        
        authSession.start()
    }
    
    func getLoginUrl() throws -> URL{
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/v2/auth"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "227613615247-pblokf6cce9hf4u6d1tn3au59ll2q8u6.apps.googleusercontent.com"),
            URLQueryItem(name: "redirect_uri", value: "com.googleusercontent.apps.227613615247-pblokf6cce9hf4u6d1tn3au59ll2q8u6:"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: "https://www.googleapis.com/auth/contacts"),
        ]
        
        return try components.asURL()
    }
    
    func startLogin(url: URL?, error: Error?) {
        if error == nil {
            let queryItems = URLComponents(string: url!.absoluteString)?.queryItems
            let token = queryItems?.filter({ $0.name == "code" }).first?.value
            
            if let token = token {
                getAccessToken(authCode: token)
            }
        }
    }
    
    func getAccessToken(authCode: String) {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth2.googleapis.com"
        components.path = "/token"
        components.queryItems = [
            URLQueryItem(name: "client_id", value: "227613615247-pblokf6cce9hf4u6d1tn3au59ll2q8u6.apps.googleusercontent.com"),
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "redirect_uri", value: "com.googleusercontent.apps.227613615247-pblokf6cce9hf4u6d1tn3au59ll2q8u6:"),
        ]
        
        guard let url = try? components.asURL() else {return}
        
        AF.request(url, method: .post).responseJSON { response in
            switch response.result {
            case .success:
                    guard let data = response.data else {return}
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let accessToken = json["access_token"] as? String {
                                self.changeAccessToken(accessToken: accessToken)
                            }
                        }
                        SyncManager.shared.syncDatabase()
                    } catch let error {
                        print(error.localizedDescription)
                    }
                case .failure(let httpError):
                    print(httpError)
                }
        }
        
    }
    
    func changeAccessToken(accessToken: String) {
        userData.userAccessToken = accessToken
    }
    
}
