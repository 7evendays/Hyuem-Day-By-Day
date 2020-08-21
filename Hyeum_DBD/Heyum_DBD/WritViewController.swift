//
//  WritViewController.swift
//  Heyum_DBD
//
//  Created by 장지원 on 2020/08/21.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit
import FSCalendar


class ViewController: UIViewController, FSCalendarDelegate {

    //@IBOutlet weak var writtingbutton: UIButton!
    //버튼 클릭하면 글쓰러 갈 수 있음
    @IBAction func gotowritting(_ sender: Any) {
        
      if let controller = self.storyboard?
        .instantiateViewController(withIdentifier: "NewViewController"){
        
        self.navigationController?.pushViewController(controller, animated: true)
        }
    }//여기까지가 글쓰기 버튼(+) 누르면 글쓰는 화면으로 넘어가는 부분, segue로 연결하지 않고 코드로 작성했습니다. 오류가 생긴다면 +버튼과 글쓰기 화면을 잇는 segue를 지우면 될 것 같아요
    
    let keyword = ["날씨","저녁","매미","여행","빙수","소나기","태양","거울","숲","이불","노을","감기약","터널","공백","아침햇살","물방울","각설탕","건널목","징검다리","신호등","별똥별","탄산","웃는얼굴","거미",
                     "홍차","베개","자갈동","구름","고래","불면증","필름"]

    
    @IBOutlet var calendar: FSCalendar!//calender는 추가하신 이름으로 바꿔주시면 됩니다.밑에서도 calender라는 레퍼런스는 추가하셨던 이름으로 교체해주세요
    
    @IBOutlet weak var todayskey1: UILabel!//오늘의 키 주제화면
    @IBOutlet weak var todayskey2: UILabel!//오늘의 키 글쓰기 화면
    
    @IBOutlet weak var randomy: UILabel!//랜덤으로 이름 바뀌는 부분 레이블(주제화면)
    @IBOutlet weak var randomy2: UILabel!//랜덤으로 이름 바뀌는 부분 레이블(글쓰기 화면)
    @IBOutlet weak var today: UILabel!//날짜 표시하는 레이블
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        // Do any additional setup after loading the view.
        
    }
    //캘린더에서 날짜 클릭하면 원고지 위에 있는 레이블 값이 바뀌는 부분
    //이제 해야하는 것: 날짜 클릭했을 때 내가 만든 화면 및 글쓰는 화면 나오는 이벤트
    func calendar(_calender: FSCalendar, didSelect date: Date, at monthposition: FSCalendarMonthPosition){
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        
        today.text = "yyyy년 MM월 dd일"
        
        
        if ("yyyy년 MM월 dd일" == "2020년 08월 15일"){
            randomy.text = "광복, 빼앗긴 주권을 도로 찾음"
        }else{
            randomy.text = keyword.randomElement()
        }//8월 15일이면 정해진 키워드를 보여주고 그 이외의 날짜는 랜덤 출력
        
        randomy.font = UIFont(name: "MapoGolgenPier", size: 35)//폰트적용하기
        randomy2.font = UIFont(name: "MapoGolgenPier", size: 35)//폰트적용하기
        
        
    }

}

