//
//  ViewController.swift
//  MAD2_ASG
//
//  Created by Marcus on 21/1/22.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {

    @IBOutlet weak var imageview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://uploads.mangadex.org/data/0d5a5a46a437ab5f2b328e7888169584/x8-e7587084aab2d65eb6b853af8c082452e171d3b76ebc7564e0935f7290986dda.png")
        imageview.kf.setImage(with: url)
    }


}

