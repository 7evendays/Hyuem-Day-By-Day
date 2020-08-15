//
//  DataManager.swift
//  Hyeum
//
//  Created by 김정현 on 2020/08/09.
//  Copyright © 2020 SWU_Hyeum. All rights reserved.
//

import Foundation
import CoreData

class DataManager
{
    //DataManager 클래스는 싱글톤으로 구현
    static let shared = DataManager()
    //공유 인스턴스를 저장할 타입 프로퍼티를 추가
    private init()
    {
        
    }
    //기본생성자를 추가하고 프라이빗으로 선언
    //앱 전체에서 하나의 인스턴스를 공유할 수 있음
    
    var mainContenxt: NSManagedObjectContext
    {
        return persistentContainer.viewContext
    }
    //새로운 속성 추가
    //CoreData에서 실행하는 대부분의 작업은 contenxt 객체가 담당
    //기본적으로 생성되는 contenxt를 그대로 사용
    
    
    //메모를 데이터베이스에서 읽어오는 코드 구현
    var memoList = [Memo]()
    //메모를 저장할 배열을 선언하고 빈 배열로 초기화
    
    func fetchMemo()
    {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        //데이터를 데이터베이스에서 읽어올 때는 fetch request를 만들어야 함
        
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        //CoreData가 리턴해주는 데이터는 기본적으로 정렬되어있지 않기 떄문에 SortDescriptor를 만들어 원하는 방식으로 정렬해야함
        //최근 메모가 먼저 표시되도록 날짜를 내림차순으로 정렬
        
        do
        {
            memoList = try mainContenxt.fetch(request)
            //fetch 매소드가 리턴하는 결과를 memoList 배열에 저장
        }
        catch
        {
            print(error)
        }
        //fetchRequest를 실행하고 데이터를 가져옴
        //fetchRequest를 사용할 때는 context 객체가 제공하는 fetch 매소드를 사용, 단 이 매소는 실행했을 때 예외가 발생할 수 있음(throws)
        //일반 매소드처럼 호출하면 에러가 발생하므로 do catch 블록을 사용해서 호출해야 함
    }
    //새로운 매소드 추가
    //fetch: 데이터를 데이터베이스에서 읽어오는 것
    
    func addNewMemo(_ memo: String?)
    {
        let newMemo = Memo(context: mainContenxt)
        //새로운 메모 인스턴스 생성
        //Memo 클래스는 CoreData가 만든 클래스이기 때문에 생성자로 contenxt를 전달해야함
        //데이터베이스에 메모를 저장하는 데 필요한 빈 인스턴스가 생성
        
        //빈 인스턴스값을 채움
        newMemo.content = memo
        //content 속성에는 파라미터로 전달된 memo를 저장
        newMemo.insertDate = Date()
        //insertDate 속성에는 현재 날짜를 그대로 저장
        //아직 데이터베이스에 저장 안됨, contenxt를 저장해야 데이베이스 파일에 저장됨
        
        memoList.insert(newMemo, at: 0)
        //배열 가장 앞부분에 새로운 메모 추가
        //fetchMemo 매소드를 다시 호출한 것과 같음
        
        saveContext()
        //contenxt를 저장하는 매소드 호출
    }
    
    //삭제 매소드 구현
    func deleteMemo(_ memo: Memo?)
    //파라미터는 옵셔널로 선언. 실제로 메모가 전달된 경우에만 삭제.
    {
        if let memo = memo
        {
            mainContenxt.delete(memo)
            saveContext()
            //contenxt가 제공하는 delete 매소드를 호출한 후 context를 저장하면 실제로 메모가 삭제됨
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Hyeum")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
