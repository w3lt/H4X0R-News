//
//  WebView.swift
//  H4X0R
//
//  Created by John Silver on 19/11/2023.
//

import Foundation
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let urlString: String?;
    
    func makeUIView(context: Context) -> UIView {
        WKWebView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let safeString = urlString {
            if let url = URL(string: safeString) {
                let request = URLRequest(url: url);
                (uiView as! WKWebView).load(request);
            }
        }
    }
}
