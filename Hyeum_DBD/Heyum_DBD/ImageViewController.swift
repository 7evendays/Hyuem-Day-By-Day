//
//  ImageViewController.swift
//  Heyum_DBD
//
//  Created by swuad_03 on 21/08/2020.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit


class ImageViewController: UIViewController {
    
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var Font1: UIButton!
    @IBOutlet weak var Font2: UIButton!
    @IBOutlet weak var Font3: UIButton!
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
           if let error = error {
            // we got back an error!
               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
            
           } else {
               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           }
       }
       
       override func viewDidLoad() {
           super.viewDidLoad()
        
        Font1.titleLabel?.font =  UIFont(name: "BinggraeMelona", size: 18)
        Font2.titleLabel?.font =  UIFont(name: "SCDream4", size: 18)
        Font3.titleLabel?.font =  UIFont(name: "MapoGoldenPier", size: 18)
        
           // Do any additional setup after loading the view.
       }
  
    @IBOutlet weak var Text: UILabel! // 이전 화면에서 저장 옵션을 클릭하면 다음 화면으로 텍스트를 넘겨 주는 걸로 생각. 넘겨받은 텍스트.
    
    @IBAction func Font1(_ sender: UIButton) {
        Text.font = UIFont(name: "BinggraeMelona", size: 18)
    }
    
    @IBAction func Font2(_ sender: UIButton) {
         Text.font = UIFont(name: "SCDream4", size: 18)
    }
    
    @IBAction func Font3(_ sender: UIButton) {
        Text.font = UIFont(name: "MapoGoldenPier", size: 18)
    }
    
    
    
    @IBAction func btn(_ sender: Any) {
        let screenshot = self.view.takeScreenshot()
              
              UIImageWriteToSavedPhotosAlbum(screenshot, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil) // 카메라롤에 저장
    }
    
}

extension UIView {
    
    func takeScreenshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if image != nil {
            return image!
        }
        
        return UIImage()
    }
}
