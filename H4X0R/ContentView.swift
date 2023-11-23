//
//  ContentView.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import SwiftUI
import CoreData

struct ContentView: View, DetailDelegateView {
    @State var savedArticles: [SavedArticle] = [];
    @State var posts: [Post] = [];
    @State var isInSavedList: Bool = false;
    var container: NSPersistentContainer;
    @ObservedObject var networkManager = NetworkManager();
    var persistanceManager: PersistanceManager;
    
    init(container: NSPersistentContainer) {
        self.container = container;
        self.persistanceManager = PersistanceManager(context: self.container.viewContext);
    }
    
    func addSavedArticles(_ article: SavedArticle) {
        do {
            try self.persistanceManager.saveData();
            self.savedArticles.append(article);
        } catch {
            print(error.localizedDescription);
        }
    }
    
    func removeArticles(id: String) {
        do {
            for i in 0..<self.savedArticles.count {
                if (self.savedArticles[i].id! == id) {
                    print(self.savedArticles[i]);
                    try self.persistanceManager.delete(self.savedArticles[i]);
                    self.savedArticles.remove(at: i);
                }
            }
        } catch {
            print(error.localizedDescription);
        }
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List(self.posts, rowContent: { post in
                    NavigationLink(destination: DetailView(id: post.objectID, url: post.url, author: post.author!, delegate: self)) {
                        HStack {
                            Text(String(post.points ?? 0))
                            Text(post.title!)
                        }
                    }
                })
                .toolbar(content: {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {}) {
                            Image(systemName: "magnifyingglass.circle")
                        }
                    }
                    ToolbarItem(placement: .principal) {
                        Text("H4X0R NEWS")
                            .bold()
                            .font(.system(size: 30))
                    }
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button(action: {
                            self.isInSavedList = !self.isInSavedList;
                            if (self.isInSavedList) {
                                self.networkManager.fetchData(savedArticles: savedArticles) { posts in
                                    self.posts = posts;
                                }
                            } else {
                                self.networkManager.fetchData { posts in
                                    self.posts = posts;
                                }
                            }
                        }) {
                            Image(systemName: self.isInSavedList ? "archivebox.fill" : "archivebox")
                        }
                        
                    })
                })
            }
            .frame(maxWidth: .infinity)
            .edgesIgnoringSafeArea(.all)
            .listStyle(GroupedListStyle())
            .onAppear {
                do {
                    self.networkManager.fetchData { posts in
                        self.posts = posts;
                    }
                    try self.persistanceManager.loadData { savedArticles in
                        self.savedArticles = savedArticles;
                        print(self.savedArticles);
                    }
                } catch {
                    print("ERROR onAppear " + error.localizedDescription);
                }
            }
            
        }
    }
}
