//
//  OffsetX.swift
//  ScrollTab
//
//  Created by 鈴木楓香 on 2024/05/05.
//

import SwiftUI

struct OffsetXKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func offsetX(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .global)
                    
                    Color.clear
                        .preference(key: OffsetXKey.self, value: rect)
                        .onPreferenceChange(OffsetXKey.self, perform: completion)
                }
            }
    }
}
