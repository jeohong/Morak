//
//  UINavigationController+Extension.swift
//  Morak
//
//  Created by Hong jeongmin on 9/9/25.
//

import UIKit

// 스와이프시 뷰 닫히게
extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
