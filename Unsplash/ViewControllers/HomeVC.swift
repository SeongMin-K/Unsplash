//
//  HomeVC.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/29.
//

import UIKit
import Toast_Swift
import Alamofire

class HomeVC: BaseVC, UISearchBarDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchFilterSegment: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBtn: UIButton!
    
    var keyboardDismissTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    //MARK: - override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("HomeVC - viewDidLoad() called")
        
        // UI 설정
        self.config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("HomeVC - viewDidAppear() called")
        self.searchBar.becomeFirstResponder()
    }
    
    // 화면이 넘어가기 전에 준비
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("HomeVC - prepare() called / segue.identifier: \(segue.identifier)")
        
        switch segue.identifier {
        case SEGUE_ID.USER_LIST_VC:
            // 다음 화면의 뷰 컨트롤러를 가져옴
            let nextVC = segue.destination as! UserListVC
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + "🧑🏻‍💻"
            
        case SEGUE_ID.PHOTO_COLLECTION_VC:
            let nextVC = segue.destination as! PhotoCollectionVC
            guard let userInputValue = self.searchBar.text else { return }
            nextVC.vcTitle = userInputValue + "🏞"
            
        default:
            print("default")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("HomeVC - viewWillAppear() called")
        
        // 키보드 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowHandle), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideHandle), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("HomeVC - viewWillDisappear() called")
        
        // 키보드 노티피케이션 해제
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - fileprivate methods
    fileprivate func config() {
        print("HomeVC - config() called")
        
        self.searchBtn.layer.cornerRadius = 10
        
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.delegate = self
        
        self.keyboardDismissTapGesture.delegate = self
        
        self.view.addGestureRecognizer(keyboardDismissTapGesture)
    }
    
    fileprivate func pushVC() {
        var segueId: String = ""
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            print("사진 화면으로 이동")
            segueId = "toPhotoCollectionVC"
        case 1:
            print("사용자 화면으로 이동")
            segueId = "toUserListVC"
        default:
            print("default")
            segueId = "toPhotoCollectionVC"
        }
        
        // 화면 이동
        self.performSegue(withIdentifier: segueId, sender: self)
    }
    
    @objc func keyboardWillShowHandle(notification: NSNotification) {
        print("HomeVC - keyboardWillShowHandle() called")
        
        // 키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            print("keyboardSize.height: \(keyboardSize.height)")
            print("searchBtn.frame.origin.y: \(searchBtn.frame.origin.y)")
            
            if keyboardSize.height < searchBtn.frame.origin.y {
                let distance = keyboardSize.height - searchBtn.frame.origin.y
                print("키보드가 버튼을 이만큼 덮음 distance: \(distance)")
                self.view.frame.origin.y = distance + searchBtn.frame.height
            }
        }
    }
    
    @objc func keyboardWillHideHandle() {
        print("HomeVC - keyboardWillHideHandle() called")
        self.view.frame.origin.y = 0
    }
    
    //MARK: - IBAction methods
    @IBAction func onSearchBtnClicked(_ sender: UIButton) {
        print("HomeVC - onSearchBtnClicked() called / index: \(searchFilterSegment.selectedSegmentIndex)")
        
//        let url = API.BASE_URL + "search/photos"
        
        guard let userInput = self.searchBar.text else { return }
        
        // key : value 형식의 딕셔너리
//        let queryParam = ["query" : userInput, "client_id" : API.CLIENT_ID]
        
//        AF.request(url, method: .get, parameters: queryParam).responseJSON(completionHandler: { response in
//            debugPrint(response)
//        })
        
        var urlToCall: URLRequestConvertible?
        
        switch searchFilterSegment.selectedSegmentIndex {
        case 0:
            urlToCall = SearchRouter.searchPhotos(term: userInput)
        case 1:
            urlToCall = SearchRouter.searchUsers(term: userInput)
        default:
            print("default")
        }

        if let urlConvertible = urlToCall {
            AlamofireManager
                .shared
                .session
                .request(SearchRouter.searchPhotos(term: userInput))
                .validate(statusCode: 200..<401)
                .responseJSON(completionHandler: { response in
                    debugPrint(response)
                })
        }
        
        // 화면 이동
//        pushVC()
    }
    
    @IBAction func searchFilterValueChanged(_ sender: UISegmentedControl) {
//        print("HomeVC - searchFilterValueChanged() called / index: \(sender.selectedSegmentIndex)")
        
        var searchBarTitle = ""
        
        switch sender.selectedSegmentIndex {
        case 0:
            searchBarTitle = "사진 키워드"
        case 1:
            searchBarTitle = "사용자 이름"
        default:
            searchBarTitle = "사진 키워드"
        }
        
        self.searchBar.placeholder = searchBarTitle + " 입력"
        self.searchBar.becomeFirstResponder() // 포커싱 설정
    }
    
    //MARK: - UISearchBar Delegate methods
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("HomeVC - searchBarSearchButtonClicked() called")
        
        guard let userInputString = searchBar.text else { return }
        
        if userInputString.isEmpty {
            self.view.makeToast("검색 키워드를 입력해주세요", duration: 1.0, position: .center)
        } else {
            pushVC()
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("HomeVC - searchBar textDidChange() / searchText: \(searchText)")
        
        // 입력된 값이 없을 때
        if searchText.isEmpty {
            self.searchBtn.isHidden = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                searchBar.resignFirstResponder()
            })
        } else {
            self.searchBtn.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = searchBar.text?.appending(text).count ?? 0
        
        print("shouldChangeTextIn: \(inputTextCount) / text: \(text)")
        
        if inputTextCount > 12 {
            self.view.makeToast("12자까지만 입력가능합니다.", duration: 1.0, position: .center)
        }
        
        return inputTextCount <= 12
    }
    
    //MARK: - UITapGestureRecognizer Delegate methods
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        print("HomeVC - gestureRecognizer shouldRecive()")

        // 터치로 들어온 뷰 예외처리
        if (touch.view?.isDescendant(of: searchFilterSegment) == true) {
//            print("SegmentedControl Touched")
            return false
        } else if (touch.view?.isDescendant(of: searchBar) == true) {
//            print("SearchBar Touched")
            return false
        } else {
            view.endEditing(true)
//            print("View Touched")
            return true
        }
    }
}

