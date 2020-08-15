//
//  DetailViewController.swift
//  Hyeum
//
//  Created by 김정현 on 2020/08/09.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    var memo: Memo? //목록 화면에서 전달한 메모 저장

    let formatter: DateFormatter =
    {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    //공유
    @IBAction func share(_ sender: UIBarButtonItem)
    {
        guard let memo = memo?.content else { return }
        //메모 내용을 새로운 상수에 바인딩
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
        present(vc, animated: true, completion: nil)
        //activityViewController를 화면에 표시
        
        if let pc = vc.popoverPresentationController
        {
            pc.barButtonItem = sender
        }
        //아이패드에서 실행하면 이 속성에 popover 표시를 담당하는 객체가 저장되어 있음
        //popover를 표시하는 뷰나 버튼 지정
        //공유버튼을 탭하면 share 매소드가 호출되고 sender로 barbutton 아이템이 전달됨
        //형식은 UIBarButtonItem
    }
    
    //메모 삭제
    @IBAction func deleteMemo(_ sender: Any)
    {
        //경고창
        let alert = UIAlertController(title: "삭제 확인", message: "글을 삭제할까요?", preferredStyle: .alert)
        
        //삭제 버튼
        //alertAction을 생성할 때 두번째 파라미터로 destructive 스타일을 전달하면 텍스트가 빨간색으로 표시됨
        let okAction = UIAlertAction(title: "삭제", style: .destructive)
        {
            [weak self] (action) in DataManager.shared.deleteMemo(self?.memo)
            //세번째 파라미터에는 버튼을 선택했을 때 실행할 코드를 전달
            //현재 화면에 표시되어 있는 메모를 파라미터로 전달(현재 화면에 표시되어 있는 메모가 삭제됨)
            self?.navigationController?.popViewController(animated: true)
            //이전 화면으로 돌아감
            //navigatinoController가 화면 전환 담당
            //navigationController에 접근한 후 현재 화면을 pop함
        }
        alert.addAction(okAction)
        //액선을 alertController에 추가
        
        let cencelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cencelAction)
        //어떤 버튼을 선택하든지 경고창은 항상 자동으로 사라지기 때문에 경고창을 닫는 코드는 구현할 필없음. 따라서 handler에 nil을 전달.
        
        //경고창을 화면에 표시
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let vc = segue.destination.children.first as? ComposeViewController
        {
            vc.editTarget = memo
            //navigationController가 관리하는 첫번째 viewController(ComposeViewController)로 메모가 전달
        }
    }
    //툴바에 있는 버튼을 탭할 때 segue가 실행
    //sender로 툴바에 있는 버튼이 전달
    //어떤 메모를 선택했는지 이미 memo 속성에 저장되어 있으므로 memo 속성에 저장되어 있는 것을 그대로 전달
    //다만 navigationController를 통해 전달하기 때문에 최종 viewController에 접근하는 코드가 조금 달라짐
    
    var token: NSObjectProtocol?
    //notification token 저장
    
    deinit
    {
        if let token = token
        {
            NotificationCenter.default.removeObserver(token)
        }
    }
    //observer를 해제하는 코드부터 구현
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        token = NotificationCenter.default.addObserver(forName: ComposeViewController.memoDidChange, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in self?.memoTableView.reloadData() })
    }
    //observer 추가
    //memoDidChange notification에 observer 추가
    //tableView reload
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension DetailViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row
        {
            //memo 속성에 저장된 메모를 보기 화면에 표시
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
                
                cell.textLabel?.text = formatter.string(for: memo?.insertDate)
                //날짜를 첫번째 셀에 표시
                //날짜를 레이블에 표시하기 위해서는 문자열로 바꿔야함
                //문자열로 바꿀 때는 DateFormatter를 활용
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
                cell.textLabel?.text = memo?.content
                //메모를 두번째 셀에 표시
                
                return cell
        default:
            fatalError()
        }
    }
    
    
}
