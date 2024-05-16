//
//  AnalyticsView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import SwiftUI
import Charts
import TipKit

struct DonutChartView: View {
    @State var emotionTypes: [EmotionType]
    @State private var selectedCount: Int?
    @State private var selectedEmotionType: EmotionType?
    @State private var topCategories: [CategoryData] = []
    @State private var selectedTimePeriod: TimePeriod = .allTime
    private let chartTip = ChartTip()
    
    var body: some View {
        let textColor = defaultBackgroundColor
        let backgroundColor = defaultTextColor
        NavigationStack {
            VStack {
                Spacer()
                    .frame(height: 10)
                Picker("Time Period", selection: $selectedTimePeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Spacer()
                    .frame(height: 20)
                Chart(emotionTypes) { emotionType in
                    SectorMark(
                        angle: .value("Percentage", emotionType.percentage),
                        innerRadius: .ratio(0.65),
                        outerRadius: selectedEmotionType?.name == emotionType.name ? 150 : 125,
                        angularInset: 1
                    )
                    .foregroundStyle(Color(emotionType.color))
                    .cornerRadius(10)
                }
                .chartAngleSelection(value: $selectedCount)
                .chartBackground { _ in
                    if let selectedEmotionType {
                        VStack {
                            Image(selectedEmotionType.name)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text(selectedEmotionType.mandarinName)
                                .font(.custom("jf-openhuninn-2.0", size: 24))
                                .foregroundColor(Color(textColor))
                            Text("\(selectedEmotionType.percentage) %")
                                .font(.custom("jf-openhuninn-2.0", size: 20))
                                .foregroundColor(Color(textColor))
                        }
                    } else {
                        VStack {
                            Image("Neutral")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            Text("請長按圖表")
                                .foregroundColor(Color(textColor))
                                .font(.custom("jf-openhuninn-2.0", size: 16))
                        }
                    }
                }
                .shadow(color: .gray, radius: 5, x: 2, y: 2)
                .frame(height: 300)
                Spacer()
                    .frame(height: 20)
                TipView(chartTip)
                if let selectedEmotionType {
                    Text("讓我感到")
                        .font(.custom("jf-openhuninn-2.0", size: 18))
                        .foregroundColor(Color(midOrange))
                    + Text("\(selectedEmotionType.mandarinName)")
                        .font(.custom("jf-openhuninn-2.0", size: 18))
                        .foregroundColor(Color(textColor))
                    + Text("的是")
                        .font(.custom("jf-openhuninn-2.0", size: 18))
                        .foregroundColor(Color(midOrange))
                }
                Spacer()
                    .frame(height: 10)
                let maxCount = topCategories.max(by: { $0.count < $1.count })?.count ?? 1
                HStack(spacing: 10) {
                    ForEach(topCategories, id: \.name) { categoryData in
                        CategoryCircleView(categoryData: categoryData, maxCount: maxCount)
                    }
                }
                Spacer()
                Image(systemName: "arrow.down")
                    .font(.system(size: 20))
                    .foregroundColor(Color(textColor))
                Spacer()
                    .frame(height: 10)
            }
            .onChange(of: selectedTimePeriod) { _, newPeriod in
                withAnimation(.easeInOut(duration: 0.5)) {
                    emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: newPeriod)
                }
            }
            .onChange(of: selectedCount) { _, newValue in
                if let newValue {
                    withAnimation(.spring()) {
                        getSelectedEmotionType(value: newValue)
                        let generator = UISelectionFeedbackGenerator()
                        generator.selectionChanged()
                    }
                }
                chartTip.invalidate(reason: .actionPerformed)
            }
            .onChange(of: selectedEmotionType) { _, newValue in
                if let emotionType = newValue {
                    topCategories = DiaryManager.shared.topCategories(forEmotion: emotionType.name)
                }
            }
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            .background(Color(backgroundColor))
        }
    }
    
    private func getSelectedEmotionType(value: Int) {
        var cumulativeTotal = 0
        let emotionType = emotionTypes.first { emotionType in
            cumulativeTotal += emotionType.percentage
            if value <= cumulativeTotal {
                selectedEmotionType = emotionType
                return true
            }
            return false
        }
    }
}

struct CategoryCircleView: View {
    var categoryData: CategoryData
    var maxCount: Int
    @State private var scale: CGFloat = 0.1
    
    var body: some View {
            let scaledCount = sqrt(CGFloat(categoryData.count) / CGFloat(maxCount))
            let diameter = max(scaledCount * 90, 20)
            
            ZStack {
                Circle()
                    .frame(width: diameter, height: diameter)
                    .foregroundColor(Color(defaultBackgroundColor))
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.5)) {
                            scale = 1.0
                        }
                    }
                    .onDisappear {
                        scale = 0.1
                    }
                Text(categoryData.name)
                    .foregroundColor(Color(defaultTextColor))
                    .font(.custom("jf-openhuninn-2.0", size: 16))
                    .scaleEffect(scale)
                    .opacity(scale)
                    .animation(.easeOut(duration: 0.5), value: scale)
            }
            .shadow(color: .gray, radius: 5, x: 2, y: 2)
    }
}






