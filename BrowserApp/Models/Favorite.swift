//
//  Favorite.swift
//  BrowserApp
//
//  Created by Jose Martins on 19/10/20.
//

import Foundation

class Favorite {
    var url: String!
    var date: String!
    
    init(url: String, date: String) {
        self.date = date
        self.url = url
    }
}
