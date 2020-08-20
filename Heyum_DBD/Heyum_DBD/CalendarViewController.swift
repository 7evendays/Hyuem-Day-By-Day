//
//  CalendarViewController.swift
//  Heyum_DBD
//
//  Created by 김정현 on 2020/08/18.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import FSCalendar
import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate
{
    @IBOutlet weak var calendar: FSCalendar!
    
    
    let dateFormatter = DateFormatter()
    
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        calendar.delegate = self
    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        view.addSubview(calendar)
    }
    
    func calendar(_calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition)
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd EEEE"
        let string = formatter.string(from: date)
        print("\(string)")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
