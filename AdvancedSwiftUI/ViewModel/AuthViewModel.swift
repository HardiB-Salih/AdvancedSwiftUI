//
//  AuthViewModel.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import Foundation
import Firebase

final class AuthViewModel: ObservableObject {
    @Published var showAlertView: Bool = false
    @Published var alertTitle: String = ""
    @Published var alertMessage: String = ""
    
    
    func createUserWithEmail(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.alertTitle = "Uh-oh!"
                self.alertMessage = error!.localizedDescription
                self.showAlertView.toggle()
//                print(error!.localizedDescription)
                return
            }
            
            print("User is signed up!")
        }
    }
    
    func signinWithEmail(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.alertTitle = "Uh-oh!"
                self.alertMessage = error!.localizedDescription
                self.showAlertView.toggle()
//                print(error!.localizedDescription)
                return
            }
            
            print("User is signed in!")
        }
    }
    
    func sendPasswordResetEmail(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            guard error == nil else {
//                print(error!.localizedDescription)
                self.alertTitle = "Uh-oh!"
                self.alertMessage = error!.localizedDescription
                self.showAlertView.toggle()
                return
            }
            self.alertTitle = "Password reset email sent"
            self.alertMessage = "Check your inbox for an email to reset your password"
            self.showAlertView.toggle()
//            print("Password reset email sent")
        }
    }
    
    func signout() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            self.alertTitle = "Uh-oh!"
            self.alertMessage = error.localizedDescription
            self.showAlertView.toggle()
//            print(error.localizedDescription)
            
        }
    }
}
