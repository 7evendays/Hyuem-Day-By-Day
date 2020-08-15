//
//  MemoListTableViewController.swift
//  Hyeum
//
//  Created by 김정현 on 2020/08/09.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController {
    let formatter: DateFormatter =
    {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        //viewWillAppear 매소드는 viewController가 관리하는 뷰가 화면에 표시되기 직전에 호출
        
        DataManager.shared.fetchMemo()
        //fetchMemo 매소드 호출: 배열이 데이터로 채워짐
        tableView.reloadData()
        //reloadData 매소드 호출: 배열에 저장된 데이터를 기반으로 tableView가 업데이트 됨
        
        
//        tableView.reloadData()
//        print(#function)
    }

    
    var token: NSObjectProtocol?
    
    deinit
    {
        if let token = token
        {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    //이 매소드는 새그웨이가 연결된 화면을 생성하고 화면을 전환하기 직전에 호출
    //sender를 활용하여 몇번째 셀을 선택했는지 계산
    //sender의 형식이 옵셔널 Any로 선언되어 있는데 이를 실제 자료형인 UITableViewCell로 바꾸고 셀을 tableview로 전달해서 몇번째 위치에 있는 셀인지 확인
    //첫번째 파라미터로 현재 실행중인 새그웨이 전달
    //목록 화면과 보기 화면에 접근 가능
    {
        if let cell = sender as? UITableViewCell,
            //sender를 UITableViewCell로 타입 캐스팅
            let indexPath = tableView.indexPath(for: cell)
            //바인딩된 cell을 tableView로 전달해서 indexPath 가져옴
            //indexPath 상수를 통해 몇번째 셀인지 확인 가능
        {
            if let vc = segue.destination as? DetailViewController
            //새롭게 표시되는 화면이 destination
            //속성 형식이 UIViewController인데 메모를 전달하기 위해서는 실제 형식인 DetailViewController로 타입캐스팅 해야함
            {
                vc.memo = DataManager.shared.memoList[indexPath.row]
                //메모 속성에 접근 가능
                //배열에서 선택한 데이터를 가져와 메모 속성에 저장
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) { [weak self] (noti) in self?.tableView.reloadData() }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count //테이블뷰가 몇 개의 셀을 출력해야할지 알려줌
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let target = DataManager.shared.memoList[indexPath.row]
        //표시할 데이터 가져옴, row 속성을 이용하여 표시할 데이터를 배열에서 가져옴
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        //string from 매소드는 옵셔널값을 받을 수 없기 때문에 string for 매소드로 바꿈
        if #available(iOS 11.0, *) {
            cell.detailTextLabel?.textColor = UIColor(named: "MyLabelColor")
        }
        else
        {
            cell.detailTextLabel?.textColor = UIColor.lightGray
        }
        //레이블의 텍스트 컬러 변경
        //named 파라미터를 받는 생성자로 컬러셋의 이름을 전달하면 추가한 컬러를 쉽게 생성할 수 있음
        //컬러셋은 iOS11에서 추가된 기능이므로 이 생성자는 iOS11부터 사용할 수 있음

        return cell
    } //테이블뷰가 어떤 디자인과 데이터를 표시해야 하는지 알려줌
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    //true를 리턴하면 편집기능 활성화
    
    //편집 스타일(삭제) 지정
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        return .delete
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            let target = DataManager.shared.memoList[indexPath.row]
            DataManager.shared.deleteMemo(target)
            //데이터베이스에서 메모 삭제
            //indexPath를 사용하여 삭제할 메모를 상수에 저장
            DataManager.shared.memoList.remove(at: indexPath.row)
            //배열에서 메모 삭제
            //tableView에 표시하는 데이터는 memoList 배열에 저장되어 있음 여기에는 여전히 삭제된 메모가 저장돼 있음
            //따라서 tableView에 표시되는 셀 숫자와 배열에 저장돼 있는 데이터 숫자가 달라지면 크래시가 발생함
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            //tableView에서 셀 삭제
        }
        else if editingStyle == .insert
        {
            
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
