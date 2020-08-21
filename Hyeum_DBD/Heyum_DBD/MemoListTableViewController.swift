//
//  MemoListTableViewController.swift
//  Heyum_DBD
//
//  Created by 김정현 on 2020/08/18.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class MemoListTableViewController: UITableViewController
{
    @IBOutlet weak var KeywordLabel: UILabel!
    
    @IBAction func MemoListToDetail(_ sender: Any?)
    {
        self.performSegue(withIdentifier: "MemoListToDetail", sender: self)
    }
    
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
        super.viewDidLoad()
        
        DataManager.shared.fetchMemo()
        tableView.reloadData()
        
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
    {
        if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell)
        {
            if let vc = segue.destination as? DetailViewController
            {
                vc.memo = DataManager.shared.memoList[indexPath.row]
            }
        }
        
        
        let dest = segue.destination
        
        guard let dvc = dest as? DetailViewController else {
            return
        }
        dvc.paramTK = self.KeywordLabel.text!
    }
    //툴바에 있는 버튼을 탭할 때 segue가 실행
    //sender로 툴바에 있는 버튼이 전달
    //어떤 메모를 선택했는지 이미 memo 속성에 저장되어 있으므로 memo 속성에 저장되어 있는 것을 그대로 전달
    //다만 navigationController를 통해 전달하기 때문에 최종 viewController에 접근하는 코드가 조금 달라짐
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(forName: ComposeViewController.newMemoDidInsert, object: nil, queue: OperationQueue.main) {
            [weak self] (noti) in self?.tableView.reloadData()
        }
        
        let array = ["날씨", "저녁", "여행", "매미", "빙수", "소나기", "태양", "거울", "숲", "이불", "노을", "감기약", "터널", "공백" , "아침햇살", "물방울", "각설탕", "건널목", "징검다리", "신호등", "별똥별", "탄산", "웃는얼굴", "거미", "홍차", "베개", "자갈돌", "구름", "고래", "불면증", "수영장", "필름", "침묵", "비밀"]
        let TK = array.randomElement()
        self.KeywordLabel.text = TK
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        // #warning Incomplete implementation, return the number of rows
        return DataManager.shared.memoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let target = DataManager.shared.memoList[indexPath.row]
        cell.textLabel?.text = target.content
        cell.detailTextLabel?.text = formatter.string(for: target.insertDate)
        
        //string from 매소드는 옵셔널값을 받을 수 없기 때문에 string for 매소드로 바꿈
        if #available(iOS 11.0, *)
        {
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
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
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
