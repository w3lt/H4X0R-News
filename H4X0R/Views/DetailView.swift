//
//  DetailView.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import SwiftUI
import CoreData

protocol DetailDelegateView: View {
    var persistanceManager: PersistanceManager { get set };
    var posts: [Post] { get set };
    var savedArticles: [SavedArticle] { get set };
    func addSavedArticles(_ article: SavedArticle);
    func removeArticles(id: String);
}

struct DetailView: View {
    let id: String;
    let url: String?;
    let author: String;
    
    @State var isSaved: Bool = false;
    var delegate: any DetailDelegateView;
    
    init(id: String, url: String?, author: String, delegate: any DetailDelegateView) {
        self.id = id;
        self.url = url;
        self.author = author;
        self.delegate = delegate;
    }
    
    var body: some View {
        WebView(urlString: url)
            .onAppear {
                for i in delegate.savedArticles {
                    if (i.id! == self.id) {
                        self.isSaved = true;
                        break;
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        self.isSaved = !self.isSaved;
                            if (self.isSaved) {
                                let newArticle = SavedArticle(context: self.delegate.persistanceManager.context);
                                newArticle.id = self.id;
                                newArticle.author = self.author;
                                self.delegate.addSavedArticles(newArticle);
                            } else {
                                self.delegate.removeArticles(id: self.id);
                            }
                    }) {
                        Image(systemName: (self.isSaved ? "archivebox.fill" : "archivebox"))
                    }
                }
            })
    }
}
