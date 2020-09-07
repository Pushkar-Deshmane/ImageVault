//
//  ViewController.swift
//  ImageVault
//
//  Created by Pushkar Deshmane on 06/09/2020.
//  Copyright © 2020 Pushkar Deshmane. All rights reserved.
//

import UIKit

class ImageListViewController: UIViewController {
    
    //ImageData Object to get Images array
    var imagesUpdated = [ImageData]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageManager = ImageManager()
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.collectionViewLayout = customCollectionViewFlowLayout()
        
        imageManager.delegate = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        imageManager.fetchWeather()
    }
    
}

extension ImageListViewController: UICollectionViewDelegate, UICollectionViewDataSource, ImageManagerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesUpdated.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CollectionViewCell
        
        let url = URL(string: "https://picsum.photos/300/300?image=\(imagesUpdated[indexPath.row].id)")
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.imageView.image = UIImage(data: data!)
        cell.imageAuthor.text  = imagesUpdated[indexPath.row].author
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ImageViewerViewController") as? ImageViewerViewController
        
        vc?.authorName = imagesUpdated[indexPath.row].author
        vc?.imageURL = "https://picsum.photos/300/300?image=\(imagesUpdated[indexPath.row].id)"
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func didUpdateImages(_ imageManager: ImageManager, images: [ImageData]) {
        DispatchQueue.main.async {
            self.imagesUpdated = images
            self.collectionView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//CollectionView setup
class customCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let numberOfColumns: CGFloat = 2
            
            let itemWidth = (self.collectionView!.frame.width - (numberOfColumns - 1))/numberOfColumns
            return CGSize(width:itemWidth, height:itemWidth)
        }
    }
}

