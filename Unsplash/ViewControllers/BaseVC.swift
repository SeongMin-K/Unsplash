//
//  BaseVC.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/29.
//

import UIKit
import Toast_Swift

class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("BaseVC - vcTitle didSet() called / vcTitle: \(vcTitle)")
            self.title = vcTitle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUp(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 인증 실패 노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.AUTH_FAIL), object: nil)
    }
    
    //MARK: - objc methods
    @objc func showErrorPopUp(notification: NSNotification) {
        print("BaseVC - showErrorPopUp() called")
        
        if let data = notification.userInfo?["statusCode"] {
            print("showErrorPopUp() data: \(data)")
            
            // 메인 스레드(UI 스레드)에서 동작
            DispatchQueue.main.async {
                self.view.makeToast("\(data) 에러", duration: 1.5, position: .center)
            }
        }
    }
}
