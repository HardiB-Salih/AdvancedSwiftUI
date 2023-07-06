//
//  ContentView.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import SwiftUI
import CoreData
import AudioToolbox

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var editingEmailTextfield: Bool = false
    @State private var editingPasswordTextfield: Bool = false
    @State private var emailIconBounce: Bool = false
    @State private var passwordIconBounce: Bool = false
    
    private let generator = UISelectionFeedbackGenerator()
    
    
    var body: some View {
        ZStack {
            Image("background-3").resizable().aspectRatio(contentMode: .fill).edgesIgnoringSafeArea(.all)
            VStack {
                VStack (alignment: .leading, spacing: 16) {
                    Text("Sign up")
                        .font(Font.largeTitle.bold())
                        .foregroundColor(.white)
                    Text("Access to 120+ hours of courses, tutorials, and livestreams")
                        .font(.subheadline)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    signUpContent
                    passwordContent
                    signUpButtonContent
                    
                    Text("By clicking on Sign up, you agree to our Terms of service and Privacy policy")
                        .font(.footnote)
                        .foregroundColor(Color.white.opacity(0.7))
                    
                    divider
                    signInButtonContent
                    
                }.padding(20)
            }.background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .systemThinMaterialDark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            ).cornerRadius(30.0)
                .padding(.horizontal)
        }
    }
    
    
    
    
    var signUpContent: some View {
        HStack (spacing: 12.0) {
            TextfieldIcon(iconName: "envelope.open.fill", currentlyEditing: $editingEmailTextfield)
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
            TextfieldIcon(iconName: "key.fill", currentlyEditing: $editingPasswordTextfield)
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
        Button(action: {
            print("Sign up")
        }, label: {
            GradientButton(text: "Sign up")
        })
    }
    
    var divider: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color.white.opacity(0.1))
    }
    
    var signInButtonContent : some View {
        Button(action: {
            print("Switch to Sign in")
        }, label: {
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .font(.footnote)
                    .foregroundColor(Color.white.opacity(0.7))
                GradientText(text: "Sign in")
                    .font(Font.footnote)
                    .bold()
                
            }
        })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



