//
//  ComposeViewController.swift
//  Heyum_DBD
//
//  Created by 김정현 on 2020/08/18.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController
{
    var editTarget: Memo?
    var originalMemoContent: String?
    
    
    @IBAction func close(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var memoTextView: UITextView!
    
    @IBAction func save(_ sender: Any)
    {
        guard let memo = memoTextView.text, memo.count > 0 else
        {
            alert(message: "내용을 입력하세요")
            return
        }
        
//        let newMemo = Memo(content: memo)
//        Memo.dummyMemoList.append(newMemo)
        
        if let target = editTarget
        {
            target.content = memo
            DataManager.shared.saveContext()
            NotificationCenter.default.post(name: ComposeViewController.memoDidChange, object: nil)
        }
        else
        {
            DataManager.shared.addNewMemo(memo)
            NotificationCenter.default.post(name: ComposeViewController.newMemoDidInsert, object: nil)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    //token을 저장할 속성 선언
    //observer 해제할 때 사용
    
    deinit
    {
        if let token = willShowToken
        {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken
        {
            NotificationCenter.default.removeObserver(token)
        }
    }
    //소멸자 추가하고 observer 해제
    //화면이 제거되는 시점에 observer 해제
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let memo = editTarget
        {
            navigationItem.title = "글 편집"
            memoTextView.text = memo.content
            originalMemoContent = memo.content
        }
        //만약 editTarget 속성에 메모가 저장되어 있다면 title을 "글 편집"으로 설정하고 textView에 편집할 글을 표시
        //originalMemoContent에 전달된 메모 내용 저장
        else
        {
            navigationItem.title = "새 글"
            memoTextView.text = ""
        }
        //만약 저장된 메모가 없다면 title은 "새 글"로 설정하고 textView는 빈 문자열로 초기화
        
        memoTextView.delegate = self
        //viewController를 textView에 delegate로 지정
        
        //키보드가 표시되기 전에 전달되는 notification(UIResponder.keyboardWillShowNotification)부터 처리
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using:
            {
                [weak self] (noti) in guard let strongSelf = self else { return }
                //클로저에서 키보드 높이 만큼 여백 추가
                //높이는 고정된 값이 아니라 notification으로 전달된 값을 활용하여 구해야 함
                
                if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
                {
                    let height = frame.cgRectValue.height
                    //height 속성에 키보드 높이 저장
                    
                    //textView의 여백 설정
                    var inset = strongSelf.memoTextView.contentInset
                    //현재 설정값 변수에 저장
                    inset.bottom = height
                    strongSelf.memoTextView.contentInset = inset
                    //변경한 inset을 contentInset 속성에 저장
                    //bottom을 제외한 나머지 여백은 그대로 유지
                    
                    //스크롤바에 여백 추가
                    inset = strongSelf.memoTextView.scrollIndicatorInsets
                    inset.bottom = height
                    strongSelf.memoTextView.scrollIndicatorInsets = inset
                }
            })
        
        
        //키보드가 사라질 때 여백 제거
        //새로운 observer를 추가하는 코드는 addObserver 매소드를 호출하는 코드 다음에 작성
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main, using:
        {
            [weak self] (noti) in guard let strongSelf = self else { return }
            //여백을 제거하는 것이기 때문에 여백을 따로 계산할 필요없음
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            //현재 inset을 변수에 저장한 후 bottom을 0으로 바꿈
            
            //스크롤바 여백 제거
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
        })
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
        //firstResponder 입력 포거스를 가진 뷰
        //textView를 firstResponder로 만들면 textView가 선택되고 키보드가 자동으로 나타남
        navigationController?.presentationController?.delegate = self
        //viewWillAppear 매소드에서 presentatinoController의 delegate를 self로 지정
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        memoTextView.resignFirstResponder()
        //화면을 닫기 전에 firstResponder 해제
        //입력 포커스가 제거되고 키보드가 사라짐
        navigationController?.presentationController?.delegate = nil
        //viewWillDisappear 매소드에서 presentatinoController의 delegate를 nil로 지정
    }
    //편집 화면이 표시되기 직전에 delegate로 설정되었다가 편집화면이 사라지기 직전에 delegate가 해제됨
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}


extension ComposeViewController: UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    //textView에서 텍스트를 편집할 때마다 반복적으로 호출
    {
        if let original = originalMemoContent, let edited = textView.text
        //오리지널 메모와 편집된 메모를 상수에 저장
        {
            if #available(iOS 13.0, *)
            {
                isModalInPresentation = original != edited
                //fullDown으로 시트를 닫기 전에 delegate 매소드를 호출
                //iOS 13 이전 버전에서는 사용 불가능하기 때문에 availability condition을 추가
                //오리지널 메모와 편집된 메모의 내용이 다를 때 isModalInPresentation 속성에 true 저장
            }
            else
            {
                // Fallback on earlier versions
            }
        }
    }
}
//메모를 편집할 때 마다 원본과 다른지 비교하여 메모가 편집됐는지 판단함
//textView에서 메모를 편집하면 textViewDidChnage 매소드가 호출되고 오리지널 메모와 편집된 메모가 다르다면 isModalInPresentation 속성에 true 저장. 그 상태에서 시트를 fullDown하면 시트가 사라지지 않고 presentatnoControllerDidAttemptToDismiss 매소드 호출.

extension ComposeViewController: UIAdaptivePresentationControllerDelegate
//경고창 추가 - 사용자가 저장/취소 선택
{
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController)
    {
        let alert = UIAlertController(title: "알림", message: "편집한 내용을 저장할까요?", preferredStyle: .alert)
        //경고창
        
        //편집을 처리할 버튼
        let okAction = UIAlertAction(title: "확인", style: .default)
        {
            [weak self] (action) in self?.save(action)
            //경고창에서 확인 버튼을 선택하면 위 클로저가 실행됨
            //클로저 내부에서 저장 기능을 구현하는 것이 아니라 save 매소드에 이미 구현되어있으므로 그냥 호출함
        }
        alert.addAction(okAction)
        //액션을 alertController에 추가
        
        //취소 액션
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        {
            [weak self] (action) in self?.close(action)
            //앞에서 구현한 close 매소드를 그대로 호출
        }
        alert.addAction(cancelAction)
        //alertController에 액션 추가
        
        present(alert, animated: true, completion: nil)
        //present 매소드로 경고창 표시
    }
}

extension ComposeViewController
{
    static let newMemoDidInsert = Notification.Name(rawValue: "newMemoDidInsert")
    static let memoDidChange = Notification.Name(rawValue: "memoDidChange")
}
