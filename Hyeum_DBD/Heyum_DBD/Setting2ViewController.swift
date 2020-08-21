//
//  Setting2ViewController.swift
//  Heyum_DBD
//
//  Created by swuad_03 on 21/08/2020.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class Setting2ViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var images = [ "01.jpg", "02.jpg", "03.jpg", "04.jpg", "05.jpg", "06.jpg"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.green
        pageControl.currentPageIndicatorTintColor = UIColor.red
        
        imgView.image = UIImage(named: images[0])
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        imgView.image = UIImage(named: images[pageControl.currentPage])
    }
}
