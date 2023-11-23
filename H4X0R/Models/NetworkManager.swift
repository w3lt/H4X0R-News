//
//  NetworkManager.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import Foundation

class NetworkManager: ObservableObject {
    func fetchData(_ stringURL: String? = nil, completion: @escaping ([Post]) -> Void) {
        if let url = URL(string: stringURL ?? "http://hn.algolia.com/api/v1/search?tags=front_page") {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { data, response, error in
                var posts: [Post] = []
                defer {
                    DispatchQueue.main.async {
                        completion(posts);
                    }
                }
                
                if let error = error {
                    print(error)
                    return
                }

                guard let safeData = data else {
                    print("No data received")
                    return
                }

                do {
                    let results = try JSONDecoder().decode(Results.self, from: safeData);
                    posts = results.hits
                } catch {
                    print(error)
                }
            }
            task.resume();
        }
    }
    
    func fetchData(savedArticles: [SavedArticle], completion: @escaping ([Post]) -> Void) {
        var results: [Post] = [];
        let dispatchGroup = DispatchGroup();

        for article in savedArticles {
            dispatchGroup.enter();
            let stringURL = "https://hn.algolia.com/api/v1/search?tags=story_\(article.id!),author_\(article.author!)";
            self.fetchData(stringURL) { posts in
                if posts.count > 0 {
                    results.append(posts[0]);
                }
                dispatchGroup.leave()
                
            };
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(results)
        }
    }
}
