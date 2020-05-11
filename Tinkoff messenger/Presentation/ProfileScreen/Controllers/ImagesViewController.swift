//
//  ImagesViewController.swift
//  Tinkoff messenger
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var imagesCollection: UICollectionView!
    
    let imageWorker = ImageWorker()
    var imageURLs: [URL] = []
    var delegate: ImageViewControllerDelegate?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagesCollection.delegate = self
        imagesCollection.dataSource = self

        imageWorker.loadImageList { (urls, error) in
            if error == nil {
                self.imageURLs = urls
                self.imagesCollection.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.loadImage(url: self.imageURLs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let image = (collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCell).mainImage.image {
            delegate?.didSelectImage(image: image)
            self.dismiss(animated: true, completion: nil)
        }
        print("select")
    }

}
