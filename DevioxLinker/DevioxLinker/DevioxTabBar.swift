//
//  CustomTabBar.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//


import UIKit

class DevioxTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 100
        return sizeThatFits
    }
}
