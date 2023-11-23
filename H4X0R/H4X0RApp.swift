//
//  H4X0RApp.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import SwiftUI
import CoreData

@main
struct H4X0RApp: App {
    let persitanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SavedArticleModel");
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)");
            }
        }
        return container;
    } ();
    var body: some Scene {
        WindowGroup {
            ContentView(container: persitanceContainer);
        }
    }
}
