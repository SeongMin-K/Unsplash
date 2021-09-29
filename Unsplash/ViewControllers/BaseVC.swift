//
//  BaseVC.swift
//  Unsplash
//
//  Created by SeongMinK on 2021/09/29.
//

import UIKit

class BaseVC: UIViewController {
    var vcTitle: String = "" {
        didSet {
            print("BaseVC - vcTitle didSet() called / vcTitle: \(vcTitle)")
            self.title = vcTitle
        }
    }
}
