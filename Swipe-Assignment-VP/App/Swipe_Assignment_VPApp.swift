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
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ProductModel.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ListingsHomeScreen(vm: ProductViewModel())
        }
        .modelContainer(sharedModelContainer)
    }
}
