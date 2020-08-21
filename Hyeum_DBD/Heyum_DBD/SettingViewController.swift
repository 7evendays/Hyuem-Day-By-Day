//
//  SettingViewController.swift
//  Heyum_DBD
//
//  Created by swuad_03 on 21/08/2020.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController
{
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var DateTextField: UITextField!
    @IBOutlet weak var lblSending: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let locale = NSLocale(localeIdentifier: "ko_KO")
        let datepicker = UIDatePicker()
        datepicker.locale = locale as Locale
        datepicker.datePickerMode = UIDatePicker.Mode.date
        datepicker.addTarget(self, action: #selector(SettingViewController.DatepickerCh(sender:)), for: UIControl.Event.valueChanged)
        DateTextField.inputView = datepicker
    }
    @objc func DatepickerCh(sender:UIDatePicker){
        let formatter = DateFormatter();
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.none
        formatter.dateFormat = "yyyy-MM-dd"
        DateTextField.text = formatter.string(from: sender.date)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func txtSend(_ sender: Any) {
        lblSending.text = "저장되었습니다."
    }
    }

