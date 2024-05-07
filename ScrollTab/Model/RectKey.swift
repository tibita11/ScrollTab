//
//  RectKey.swift
//  ScrollTab
//
//  Created by 鈴木楓香 on 2024/05/07.
//

import SwiftUI

struct RectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func rect(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader { proxy in
                    let rect = proxy.frame(in: .named("SCROLL"))
                    
                    Color.clear
                        .preference(key: OffsetXKey.self, value: rect)
                        .onPreferenceChange(OffsetXKey.self, perform: completion)
                }
            }
    }
}
