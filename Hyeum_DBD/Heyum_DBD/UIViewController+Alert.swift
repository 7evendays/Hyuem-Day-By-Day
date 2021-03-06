//
//  UIViewController+Alert.swift
//  Heyum_DBD
//
//  Created by 김정현 on 2020/08/18.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

extension UIViewController
{
    func alert(titlle: String = "알림", message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
