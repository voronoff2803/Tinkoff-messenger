//
//  ImageWorker.swift
//  Tinkoff messenger
//
//  Created by Alexey on 12.05.2020.
//  Copyright © 2020 voronoff. All rights reserved.
//

import Foundation

class ImageWorker {
    lazy var getListLink = "https://pixabay.com/api/?key=\(apiKey)&q=yellow+flowers&image_type=photo&pretty=true&per_page=100"
    let apiKey = "16500053-b89d93ec314bd6c3e9d359a7c"
    
    func loadImageList(comletion: @escaping ([URL], String?) -> ()) {
        print(getListLink)
        let session = URLSession.shared
        guard let url = URL(string: getListLink) else { return }
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    comletion([], error.localizedDescription)
                }
                print(error.localizedDescription)
            } else if let data = data {
                if let jsonArray = try? JSONSerialization.jsonObject(with: data, options : []) as? Dictionary<String,Any> {
                    guard let hits = jsonArray["hits"] as? [Dictionary<String,Any>] else { return }
                    var urls: [URL] = []
                    hits.forEach({guard let urlString = $0["webformatURL"] as? String else {return}; guard let url = URL(string: urlString) else {return}; urls.append(url)})
                    sleep(1) // Искусственная задержка
                    DispatchQueue.main.async {
                        comletion(urls, nil)
                    }
                }
            }
        }
        task.resume()
    }
}
