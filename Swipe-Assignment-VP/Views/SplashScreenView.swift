//
//  SplashScreenView.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 11/11/24.
//

import SwiftUI

/// Splash screen view 
struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.orange
            
            Image("swipeLogo")
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashScreenView()
}
