//
//  Home.swift
//  ScrollTab
//
//  Created by 鈴木楓香 on 2024/05/05.
//

import SwiftUI

struct Home: View {
    @State private var activeTab: TabModel.Tab = .all
    @State private var dragOffset: CGFloat = 0
    @State private var indicatorOffset: CGFloat = 0
    @State private var tabs: [TabModel] = [
        .init(id: .all),
        .init(id: .original),
        .init(id: .fantasy),
        .init(id: .girl),
        .init(id: .woman),
        .init(id: .boy)
    ]
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                TabBarView(scrollViewProxy: proxy)
                TabScrollView(scrollViewProxy: proxy)
            }
        }
    }
    
    // MARK: - Tab Bar View
    @ViewBuilder
    private func TabBarView(scrollViewProxy: ScrollViewProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach($tabs, id: \.self) { $tab in
                    Button(action: {
                        withAnimation {
                            activeTab = tab.id
                            scrollViewProxy.scrollTo(activeTab, anchor: .center)
                        }
                    }, label: {
                        Text(tab.id.rawValue)
                            .fontWeight(.bold)
                            .foregroundColor(activeTab == tab.id ? .black : .gray)
                            .clipShape(.rect)
                        
                    })
                    .id(tab.id)
                    .rect { rect in
                        tab.width = rect.width
                        tab.minX = rect.minX
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 15)
        .overlay(alignment: .bottom) {
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.gray.opacity(0.3))
                    .frame(height: 1)
                
                Rectangle()
                    .fill(.black)
                    .frame(width: tabs[activeTab.index].width, height: 1.5)
                    // offsetは累計になることに注意する
                    .offset(x: indicatorOffset)
                    .offset(x: tabs[activeTab.index].minX)
            }
        }
        .coordinateSpace(name: "SCROLL")
    }
    
    // MARK: - Scroll View
    @ViewBuilder
    private func TabScrollView(scrollViewProxy: ScrollViewProxy) -> some View {
        GeometryReader { proxy in
            LazyHStack(spacing: 0) {
                ForEach(tabs) { tab in
                    TabImageView(tab: tab)
                }
                .frame(width: proxy.size.width)
            }
            // offsetは累計になることに注意する
            .offset(x: dragOffset)
            .offset(x: -CGFloat(activeTab.index) * proxy.size.width)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        // 最初のページと最後のページはスクロール幅を狭くする
                        if activeTab.index == 0, value.translation.width > 0 {
                            dragOffset = value.translation.width / 5
                        } else if activeTab.index == (tabs.count - 1), value.translation.width < 0 {
                            dragOffset = value.translation.width / 5
                        } else {
                            dragOffset = value.translation.width
                        }
                    })
                    .onChanged({ value in
                        // 右に進む
                        if activeTab.index != (tabs.count - 1), value.translation.width < 0 {
                            withAnimation {
                                indicatorOffset = getIndicatorOffset(
                                    currentIndex: activeTab.index,
                                    nextIndex: activeTab.index + 1,
                                    tabWidth: proxy.size.width,
                                    translationWidth: value.translation.width
                                )
                            }
                        }
                        // 左に進む
                        if activeTab.index != 0, value.translation.width > 0 {
                            withAnimation {
                                indicatorOffset = getIndicatorOffset(
                                    currentIndex: activeTab.index,
                                    nextIndex: activeTab.index - 1,
                                    tabWidth: proxy.size.width,
                                    translationWidth: value.translation.width
                                )
                            }
                        }
                    })
                    .onEnded { value in
                        var newIndex = activeTab.index
                        // ドラッグ幅からページング判定
                        if abs(value.translation.width) > proxy.size.width * 0.3 {
                            newIndex = value.translation.width > 0 ? activeTab.index - 1 : activeTab.index + 1
                        }
                        // 最小値と、最大値を超えないようチェック
                        if newIndex < 0 {
                            newIndex = 0
                        } else if newIndex > (self.tabs.count - 1) {
                            newIndex = self.tabs.count - 1
                        }
                        withAnimation {
                            dragOffset = 0
                            indicatorOffset = 0
                            activeTab = tabs[newIndex].id
                            scrollViewProxy.scrollTo(activeTab, anchor: .center)
                        }
                    }
            )
        }
    }
    
    // MARK: - Tab Image View
    @ViewBuilder
    private func TabImageView(tab: TabModel) -> some View {
        Image(tab.id.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    /// Scroll幅からLabelの進む距離を計算
    private func getIndicatorOffset(currentIndex: Int, nextIndex: Int, tabWidth: CGFloat, translationWidth: CGFloat) -> CGFloat {
        let startPoint = tabs[currentIndex].minX
        let endPoint = tabs[nextIndex].minX
        let width = endPoint - startPoint
        // ラベル間の距離と、タブ幅から進む距離を計算
        let offset = (width / tabWidth) * abs(translationWidth)
        return offset
    }
}

#Preview {
    ContentView()
}
