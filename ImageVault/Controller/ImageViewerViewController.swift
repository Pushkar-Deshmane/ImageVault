//
//  ImageViewerViewController.swift
//  ImageVault
//
//  Created by Pushkar Deshmane on 07/09/2020.
//  Copyright © 2020 Pushkar Deshmane. All rights reserved.
//

import UIKit

class ImageViewerViewController: UIViewController {
    
    @IBOutlet weak var imageViewDetail: UIImageView!
    @IBOutlet weak var imageAuthorDetail: UILabel!
    
    var imageURL = ""
    var authorName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imageAuthorDetail.text = authorName
        
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        imageViewDetail.image = UIImage(data: data!)
    }
    
}
