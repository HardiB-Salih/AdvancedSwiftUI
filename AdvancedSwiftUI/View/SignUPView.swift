//
//  SignUPView.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import SwiftUI
import AudioToolbox
import Firebase

struct SignUPView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var editingEmailTextfield: Bool = false
    @State private var editingPasswordTextfield: Bool = false
    @State private var emailIconBounce: Bool = false
    @State private var passwordIconBounce: Bool = false
    @State private var showProfileView: Bool = false
    @State private var signupToggle: Bool = true
    @State private var rotationAngle = 0.0
    @State private var signInWithAppleObject = SignInWithAppleObject()
    
    @State private var fadeToggle: Bool = true

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Account.userSince, ascending: true)], animation: .default) private var savedAccounts: FetchedResults<Account>

    
    private let generator = UISelectionFeedbackGenerator()
    
    var body: some View {
        ZStack {
            Image(signupToggle ? "background-3" : "background-1")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 1.0 : 0.0)
            
            Color("secondaryBackground")
                .edgesIgnoringSafeArea(.all)
                .opacity(fadeToggle ? 0.0 : 1.0)
            
            VStack {
                VStack (alignment: .leading, spacing: 16) {
                    Text(signupToggle ? "Sign up" : "Sign in")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Access to 120+ hours of courses, tutorials, and livestreams")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    signUpContent
                    passwordContent
                    signUpButtonContent
                    
                    if signupToggle {
                        Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                            .font(.footnote)
                            .foregroundColor(Color.white.opacity(0.7))
                        divider
                    }
                    signInButtonContent
                    if !signupToggle {
                        Button(action: {
                            authViewModel.sendPasswordResetEmail(email: email)
                        }, label: {
                            HStack(spacing: 4) {
                                Text("Forgot password?")
                                    .font(.footnote)
                                    .foregroundColor(.white.opacity(0.7))
                                GradientText(text: "Reset password")
                                    .font(.footnote.bold())
                            }
                        })
                        
                        Button(action: {
                            signInWithAppleObject.signInWithApple()
                        }, label: {
                            SignInWithAppleButton()
                                .frame(height: 50)
                                .cornerRadius(16)
                        })
                    }
                    
                    
                    
                }.padding(20)
            }
            .rotation3DEffect(Angle(degrees: self.rotationAngle), axis: (x: 0.0, y: 1.0, z: 0.0))
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            ).cornerRadius(30.0)
                .padding(.horizontal)
                .rotation3DEffect(Angle(degrees: self.rotationAngle), axis: (x: 0.0, y: 1.0, z: 0.0))
                .alert(isPresented: $authViewModel.showAlertView) {
                    Alert(title: Text(authViewModel.alertTitle), message: Text(authViewModel.alertMessage), dismissButton: .cancel())
                }
            
        }
        .fullScreenCover(isPresented: $showProfileView) {
            ProfileView()
        }
    }
    
    
    
    
    var signUpContent: some View {
        HStack (spacing: 12.0) {
            TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextfield, passedImage: .constant(nil))
                .scaleEffect(emailIconBounce ? 1.2 : 1.0)
            TextField("Email", text: $email) { isEditing in
                editingEmailTextfield = isEditing
                editingPasswordTextfield = false
                if isEditing {
                    generator.selectionChanged()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        emailIconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5).delay(0.15)) {
                            emailIconBounce.toggle()
                        }
                    }
                    
                }
            }
            .colorScheme(.dark)
            .foregroundColor(Color.white.opacity(0.7))
            .autocapitalization(.none)
            .textContentType(.emailAddress)
        }.frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 1.0)
                    .blendMode(.overlay)
            )
            .background(
                Color("secondaryBackground")
                    .cornerRadius(16.0)
                    .opacity(0.8)
            )
    }
    var passwordContent: some View {
        HStack (spacing: 12.0) {
            TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextfield, passedImage: .constant(nil))
                .scaleEffect(passwordIconBounce ? 1.2 : 1.0)
            PasswordSecureField(placeholder: "Password", text: $password) { isEditing in
                editingPasswordTextfield = isEditing
                editingEmailTextfield = false
                
                if isEditing {
                    generator.selectionChanged()
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5)) {
                        passwordIconBounce.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.5).delay(0.15)) {
                            passwordIconBounce.toggle()
                        }
                    }
                    
                }
            }
            .colorScheme(.dark)
            .foregroundColor(Color.white.opacity(0.7))
            .autocapitalization(.none)
            .textContentType(.password)
        }.frame(height: 52)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.white, lineWidth: 1.0)
                    .blendMode(.overlay)
            )
            .background(
                Color("secondaryBackground")
                    .cornerRadius(16.0)
                    .opacity(0.8)
            )
            .onTapGesture {
                editingPasswordTextfield = true
                editingEmailTextfield = false
            }
    }
    
    var signUpButtonContent : some View {
        GradientButton(buttonTitle: signupToggle ? "Create account" : "Sign in") {
            if signupToggle {
                authViewModel.createUserWithEmail(email: email, password: password)
            } else {
                authViewModel.signinWithEmail(email: email, password: password)
            }
            
            
            
            
            
        }.onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if let currentUser = user {
                    if savedAccounts.count == 0 {
                        // Add data to Core Data
                        
                        let userDataToSave = Account(context: viewContext)
                        userDataToSave.name = currentUser.displayName
                        userDataToSave.bio = nil
                        userDataToSave.userID = currentUser.uid
                        userDataToSave.numberOfCertificates = 0
                        userDataToSave.proMember = false
                        userDataToSave.twitterHandle = nil
                        userDataToSave.website = nil
                        userDataToSave.profileImage = nil
                        userDataToSave.userSince = Date()
                        do {
                            try viewContext.save()
                            DispatchQueue.main.async {
                                showProfileView.toggle()
                            }
                        } catch let error {
                            print(error.localizedDescription)
//                            alertTitle = "Could not create an account"
//                            alertMessage = error.localizedDescription
//                            showAlertView.toggle()
                        }
                        
                    } else {
                        showProfileView.toggle()
                    }
                }
            }
        }
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.white.opacity(0.1))
    }
    
    var signInButtonContent : some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.35)) {
                    fadeToggle.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            self.fadeToggle.toggle()
                        }
                    }
                }
            
            
            withAnimation(.easeInOut(duration: 0.7)){
                signupToggle.toggle()
                self.rotationAngle += 180
            }
        }, label: {
            HStack(spacing: 4) {
                Text(signupToggle ? "Already have an account?" : "Don't have an account?")
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.7))
                GradientText(text:  signupToggle ? "Sign in" : "Sign up")
                    .font(Font.footnote)
                    .bold()
                
            }
        })
    }
}

struct SignUPView_Previews: PreviewProvider {
    static var previews: some View {
        SignUPView()
    }
}
