//
//  ImageCollectionViewCell.swift
//  Tinkoff messenger
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mainImage: UIImageView!
    var currentURL: URL?
    
    func loadImage(url: URL) {
        self.currentURL = url
        self.mainImage.image = nil
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if url == self?.currentURL {
                            self?.mainImage.image = image
                        }
                    }
                }
            }
        }
    }
}
