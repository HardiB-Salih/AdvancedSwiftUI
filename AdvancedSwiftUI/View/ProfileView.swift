//
//  ProfileView.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var authViewModel = AuthViewModel()
    @StateObject private var purchaseHelper = InAppPurchaseNonConsumableHelper()
    @State private var showSettingsView: Bool = false
    
    var body: some View {
        ZStack {
            Image("background-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 16) {
//                        ZStack {
//                            Circle()
//                                .foregroundColor(Color("pink-gradient-1"))
//                                .frame(width: 66, height: 66, alignment: .center)
//                            Image(systemName: "person.fill")
//                                .foregroundColor(.white)
//                                .font(.system(size: 24, weight: .medium, design: .rounded))
//                        } .frame(width: 66, height: 66, alignment: .center)
                        
                        GradientProfilePictureView(profilePicture: UIImage(named: "Profile")!)
                            .frame(width: 66, height: 66, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text("Hardi B. Salih")
                                .foregroundColor(.white)
                                .font(.title2)
                                .bold()
                            Text("View profile")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.footnote)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showSettingsView.toggle()
//                            print("Segue to settings")
                        }, label: {
                            TextfieldIcon(iconName: "gearshape.fill", currentlyEditing: .constant(true), passedImage: .constant(nil))
                        })
                    }
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    
                    Text("Instructor at Design+Code")
                        .foregroundColor(.white)
                        .font(.title2.bold())
                    
                    Label("Awarded 10 certificates since September 2020", systemImage: "calendar")
                        .foregroundColor(.white.opacity(0.7))
                        .font(.footnote)
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.white.opacity(0.1))
                    
                    HStack(spacing: 16) {
                        Image("Twitter")
                            .resizable()
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 24, height: 24, alignment: .center)
                        Image(systemName: "link")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.system(size: 17, weight: .semibold, design: .rounded))
                        Text("designcode.io")
                            .foregroundColor(.white.opacity(0.7))
                            .font(.footnote)
                    }
                }.padding(16)
                
                GradientButton(buttonTitle: "Purchase Lifetime Pro Plan") {
//                    print("IAP")
                    if let product = purchaseHelper.products.first {
                        purchaseHelper.purchase(product: product)
                    }
                }.onAppear {
                    // Fetch the available products when the view appears
                        purchaseHelper.fetchProducts(productIdentifiers: ["lifetime_pro_plan"])
                }
                .padding(.horizontal, 16)
                
                Button(action: {
                    print("Restore")
                }, label: {
                    GradientText(text: "Restore Purchases")
                        .font(.footnote.bold())
                })
                .padding(.bottom)
            }.background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.white.opacity(0.2))
                    .background(Color("secondaryBackground").opacity(0.5))
                    .background(VisualEffectBlur(blurStyle: .dark))
                    .shadow(color: Color("shadowColor").opacity(0.5), radius: 60, x: 0, y: 30)
            ).cornerRadius(30)
                .padding(.horizontal)
            
            VStack {
                Spacer()
                Button(action: {
//                    print("Sign out")
                    authViewModel.signout()
                }, label: {
                    Image(systemName: "arrow.turn.up.forward.iphone.fill")
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .rounded))
                        .rotation3DEffect(
                            Angle(degrees: 180),
                            axis: (x: 0.0, y: 0.0, z: 1.0)
                        )
                        .background(
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                .frame(width: 42, height: 42, alignment: .center)
                                .overlay(
                                    VisualEffectBlur(blurStyle: .dark)
                                        .cornerRadius(21)
                                        .frame(width: 42, height: 42, alignment: .center)
                                )
                        )
                })
            }
            .padding(.bottom, 64)
        }.colorScheme(.dark)
            .sheet(isPresented: $showSettingsView) {
                SettingsView()
            }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
