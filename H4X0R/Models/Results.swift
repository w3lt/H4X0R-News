//
//  Results.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import Foundation

class Results: Decodable {
    let hits: [Post];
}

class Post: Decodable, Identifiable {
    let objectID: String;
    let points: Int?;
    let title: String?;
    let url: String?;
    let author: String?;
}
