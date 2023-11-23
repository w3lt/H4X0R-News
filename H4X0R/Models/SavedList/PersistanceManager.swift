//
//  SavedListPersistanceContainer.swift
//  H4X0R
//
//  Created by John Silver on 23/11/2023.
//

import Foundation
import CoreData

class PersistanceManager {
    public let context: NSManagedObjectContext;
    
    init(context: NSManagedObjectContext) {
        self.context = context;
    }
    
    func loadData(completion: @escaping ([SavedArticle]) -> Void) throws {
        var results: [SavedArticle] = [];
        defer {
            DispatchQueue.main.async {
                completion(results);
            }
        }
        let request = SavedArticle.fetchRequest();
        results = try context.fetch(request);
    }
    
    func saveData() throws {
        do {
            guard self.context.hasChanges else { return };
            try self.context.save();
        } catch {
            print(error.localizedDescription)
        }
    }
        
    func isSaved(id: String) throws -> Bool {
        var result = false
        var semaphore = DispatchSemaphore(value: 0)

        try self.loadData { savedArticles in
            for i in savedArticles {
                if let articleID = i.id, articleID == id {
                    result = true
                    break
                }
            }

            semaphore.signal()
        }

        semaphore.wait()
        return result;
    }
    
    func delete(_ article: SavedArticle) throws {
        self.context.delete(article);
        try self.saveData();
    }
}
