//
//  TabModel.swift
//  ScrollTab
//
//  Created by 鈴木楓香 on 2024/05/05.
//

import Foundation

struct TabModel: Identifiable, Hashable {
    let id: Tab
    var width: CGFloat = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case all = "すべて"
        case original = "オリジナル"
        case fantasy = "ファンタジー"
        case girl = "少女"
        case woman = "女性"
        case boy = "少年"
        
        var image: String {
            switch self {
            case .all:
                return "image1"
            case .original:
                return "image2"
            case .fantasy:
                return "image3"
            case .girl:
                return "image4"
            case .woman:
                return "image5"
            case .boy:
                return "image6"
            }
        }
        
        // Tab Index
        var index: Int {
            return Tab.allCases.firstIndex(of: self) ?? 0
        }
        
        // Total Count
        var count: Int {
            return Tab.allCases.count
        }
    }
}
