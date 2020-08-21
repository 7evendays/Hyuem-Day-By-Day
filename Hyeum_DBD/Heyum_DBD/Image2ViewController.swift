//
//  Image2ViewController.swift
//  Heyum_DBD
//
//  Created by swuad_03 on 21/08/2020.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit
import Photos

var image:UIImage = UIImage()

class CaptureViewController: UIViewController {
    
    @IBOutlet weak var myImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myImage.image = image
}
}
