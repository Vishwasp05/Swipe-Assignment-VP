//
//  Swipe_Assignment_VPApp.swift
//  Swipe-Assignment-VP
//
//  Created by Vishwas Sharma on 10/11/24.
//



import SwiftUI
import SwiftData

@main
struct Swipe_Assignment_VPApp: App {
    @State private var didShowSplashScreen = false
    let container: ModelContainer
    
    init() {
        do {

            let schema = Schema([ProductModel.self])
            let modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false
            )
            
            container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if didShowSplashScreen {
                    ListingsHomeScreen(vm: ProductViewModel())
                } else {
                    SplashScreenView()
                }
            }
            .task {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut) {
                        didShowSplashScreen = true
                    }
                }
            }
        }
        .modelContainer(container)
    }
}


