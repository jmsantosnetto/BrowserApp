//
//  FavoritesCell.swift
//  BrowserApp
//
//  Created by Jose Martins on 19/10/20.
//

import UIKit

class FavoriteCell: UITableViewCell {
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func fillUI(_ favorite: Favorite){
        self.urlLabel.text = favorite.url
        self.dateLabel.text = favorite.date
    }
}
