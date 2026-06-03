//
//  UniAccesssApp.swift
//  UniAccesss
//
//  Created by Onesto on 02/06/26.
//

import SwiftUI
import SwiftData

@main
struct UniAccesssApp: App {
    let container: ModelContainer = {
        let schema = Schema([UserAccount.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(container)
                .environmentObject(UserSession.shared)
        }
    }
}
