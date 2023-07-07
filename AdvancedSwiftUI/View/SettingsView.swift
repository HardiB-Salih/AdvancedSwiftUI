//
//  SettingsView.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/7/23.
//

import SwiftUI

struct SettingsView: View {
    @State private var editingNameTextfield = false
    @State private var editingTwitterTextfield = false
    @State private var editingSiteTextfield = false
    @State private var editingBioTextfield = false
    
    @State private var nameIconBounce = false
    @State private var twitterIconBounce = false
    @State private var siteIconBounce = false
    @State private var bioIconBounce = false
    
    @State private var name = ""
    @State private var twitter = ""
    @State private var site = ""
    @State private var bio = ""
    private let generator = UISelectionFeedbackGenerator()
    
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Settings")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.top)
                
                Text("Manage your Design+Code profile and account")
                    .foregroundColor(.white.opacity(0.7))
                    .font(.callout)
                
                
                // Choose Photo
                Button {
                    self.showImagePicker = true
//                    print("Show image picker")
                } label: {
                    HStack(spacing: 12) {
                        TextfieldIcon(iconName: "person.crop.circle", currentlyEditing: .constant(false), passedImage: $inputImage)
                        GradientText(text: "Choose Photo")
                        Spacer()
                    }.overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.1), lineWidth: 1)
                    )
                    .background(
                        Color.init(red: 26/255, green: 20/255, blue: 51/255)
                            .cornerRadius(16)
                    )
                }
                
                // Name Textfield
                GradientTextfield(editingTextfield: $editingNameTextfield, textfieldString: $name, iconBounce: $nameIconBounce, textfieldPlaceholder: "Name", textfieldIconString: "textformat.alt")
                    .autocapitalization(.words)
                    .textContentType(.name)
                    .disableAutocorrection(true)
                
                // Twitter Handle Textfield
                GradientTextfield(editingTextfield: $editingTwitterTextfield, textfieldString: $twitter, iconBounce: $twitterIconBounce, textfieldPlaceholder: "Twitter Handle", textfieldIconString: "at")
                    .autocapitalization(.none)
                    .keyboardType(.twitter)
                    .disableAutocorrection(true)
                
                // Site Textfield
                GradientTextfield(editingTextfield: $editingSiteTextfield, textfieldString: $site, iconBounce: $siteIconBounce, textfieldPlaceholder: "Website", textfieldIconString: "link")
                    .autocapitalization(.none)
                    .keyboardType(.webSearch)
                    .disableAutocorrection(true)
                
                // Bio Textfield
                GradientTextfield(editingTextfield: $editingBioTextfield, textfieldString: $bio, iconBounce: $bioIconBounce, textfieldPlaceholder: "Bio", textfieldIconString: "text.justifyleft")
                    .autocapitalization(.sentences)
                    .keyboardType(.default)
                
                GradientButton(buttonTitle: "Save Settings") {
                    // Save changes to Core Data
                    generator.selectionChanged()
                }
                Spacer()
            }.padding()
            Spacer()
        }.background(Color("settingsBackground").edgesIgnoringSafeArea(.all))
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(image: $inputImage)
            }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
