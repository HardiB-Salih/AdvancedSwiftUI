//
//  AuthViewModel.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import Foundation
import Firebase

class AuthViewModel: ObservableObject {
    
    func createUserWithEmail(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("User is signed up!")
        }
    }
    
    func signinWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            print("User is signed in!")
        }
    }
}
