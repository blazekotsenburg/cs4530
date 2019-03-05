//
//  ViewController.swift
//  WebScraper
//
//  Created by Blaze Kotsenburg on 3/4/19.
//  Copyright © 2019 Blaze Kotsenburg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    static let imageRangeStartTag = "<img"
    static let imageRangeEndTag = "/>"
    static let imageSrcStart = "src=\""
    static let imageSrcEnd = "\""
    
    let webURL = URL(string: "https://www.nytimes.com/")!
    
    let imageLock = NSLock()
    var images: [UIImage] = []
    
    var collectionView: UICollectionView {
        return view as! UICollectionView
    }
    
    override func loadView() {
        let layout = UICollectionViewFlowLayout()
        view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: String(describing: UICollectionViewCell.self))
        
        let task = URLSession.shared.dataTask(with: webURL) { [weak self] (data, response, error) in
            guard error == nil else {
                fatalError("URL dataTask failed: \(error!)")
            }
            guard let data = data,
                var dataString = String(bytes: data, encoding: .utf8) else {
                fatalError("no data to work with")
            }
            
            while !dataString.isEmpty {
                guard let nextImageStartRange = dataString.range(of: ViewController.imageRangeStartTag) else {
                    break
                }
                dataString = String(dataString[nextImageStartRange.upperBound...])
                
                guard let nextImageEndRange = dataString.range(of: ViewController.imageRangeEndTag) else {
                    break
                }
                
                var imageString = dataString[...nextImageEndRange.lowerBound]
                dataString = String(dataString[nextImageEndRange.upperBound...])
                
                guard let imageSrcStartRange = imageString.range(of: ViewController.imageSrcStart) else {
                    continue
                }
                
                imageString = imageString[imageSrcStartRange.upperBound...]
                
                guard let imageSrcEndRange = imageString.range(of: ViewController.imageSrcEnd) else {
                    break
                }
                
                imageString = imageString[..<imageSrcEndRange.lowerBound]
                print(String(imageString))
                
                let imageURL = URL(string: String(imageString))!
                self?.loadImageFrom(url: imageURL)
                
            }
        }
        task.resume()
    }
    
    func loadImageFrom(url: URL) {
        
        URLSession.shared.dataTask(with: url) { [weak self] (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                fatalError("URL data task failed: \(error!)")
            }
            
            guard let data = data else {
                fatalError("No image data to work with")
            }
            guard let image = UIImage(data: data) else {
                fatalError("Couldn't create image from data")
            }
            guard let self = self else {
                return
            }
            self.imageLock.lock()
            self.images.append(image)
            self.imageLock.unlock()
            
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
            
        }.resume()
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: UICollectionViewCell.self), for: indexPath)
        let image = images[indexPath.row]
        let imageView: UIImageView = UIImageView(image: image)
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    
}
