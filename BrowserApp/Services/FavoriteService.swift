//
//  FavoriteService.swift
//  BrowserApp
//
//  Created by Jose Martins on 19/10/20.
//

import Foundation

class FavoriteService {
    static let instance = FavoriteService()
    let favoritesKey: String = "favorites"
    let storage = UserDefaults.standard
    
    func addToFavorite(url: String) {
        let dateFormatter : DateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        let newFavorite = Favorite(url: url, date: dateString)
        var favorites = self.getFavorites()
        favorites.append(newFavorite)
        
        storage.set(self.toDictionaries(favorites), forKey: self.favoritesKey)
    }
    
    func removeFavorite(forIndex: Int) {
        var favorites = self.getFavorites()
        
        favorites.remove(at: forIndex)
        
        storage.set(self.toDictionaries(favorites), forKey: self.favoritesKey)
    }
    
    func getFavorites() -> [Favorite] {
        if let favorites = UserDefaults.standard.array(forKey: self.favoritesKey) as? [Dictionary<String, String>] {
            return self.toList(favorites).reversed()
        }
        
        return []
    }
    
    private func toDictionaries(_ list: [Favorite]) -> [Dictionary<String, String>] {
        return list.map { (favorite) -> Dictionary<String, String> in
            return ["url": favorite.url, "date": favorite.date]
        }
    }
    
    private func toList(_ dictionaries: [Dictionary<String, String>]) -> [Favorite]{
        return dictionaries.map { (favorite) -> Favorite in
            return Favorite(url: favorite["url"]!, date: favorite["date"]!)
        }
    }
}
