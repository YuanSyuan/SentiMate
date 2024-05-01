//
//  AnalyticsView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    @State var emotionTypes: [EmotionType]
    @State private var selectedCount: Int?
    @State private var selectedEmotionType: EmotionType?
    @State private var topCategories: [CategoryData] = []
    @State private var selectedTimePeriod: TimePeriod = .allTime
    
    
    var body: some View {
        let textColor = defaultTextColor
        let backgroundColor = defaultBackgroundColor
        
        NavigationStack {
            VStack {
                HStack {
                    Text("心情圖")
                        .font(.custom("jf-openhuninn-2.0", size: 36))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color(textColor))
                }
                Picker("Time Period", selection: $selectedTimePeriod) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                        
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .background(Color.gray.opacity(0.7))
                
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
                            Text("請點擊圖表")
                                .foregroundColor(Color(textColor))
                                .font(.custom("jf-openhuninn-2.0", size: 16))
                        }
                    }
                }
                .frame(height: 300)
                if let selectedEmotionType {
                    Text("讓我感到\(selectedEmotionType.mandarinName)的是")
                        .font(.custom("jf-openhuninn-2.0", size: 18))
                        .foregroundColor(Color(textColor))
                }
                
                
                let maxCount = topCategories.max(by: { $0.count < $1.count })?.count ?? 1
                
                HStack(spacing: 20) {
                    ForEach(topCategories, id: \.name) { categoryData in
                        CategoryCircleView(categoryData: categoryData, maxCount: maxCount)
                    }
                }
                
                Spacer()
            }
            .onChange(of: selectedTimePeriod) { newPeriod in
                withAnimation(.easeInOut(duration: 0.5)) {
                    emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: newPeriod)
                }
            }
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    withAnimation(.spring()) {
                        getSelectedEmotionType(value: newValue)
                    }
                }
            }
            .onChange(of: selectedEmotionType) { oldValue, newValue in
                if let emotionType = newValue {
                    topCategories = DiaryManager.shared.topCategories(forEmotion: emotionType.name)
                }
            }
            
            
            .padding()
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
    @State private var scale: CGFloat = 0.1 // Start from a scaled down state

    var body: some View {
        let scaledCount = sqrt(CGFloat(categoryData.count) / CGFloat(maxCount))
        let diameter = max(scaledCount * 100, 20) // Ensure a minimum size for visibility

        ZStack {
            Circle()
                .frame(width: diameter, height: diameter)
                .foregroundColor(Color(defaultTextColor))
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.5)) {
                        scale = 1.0 // Animate to full size
                    }
                }
                .onDisappear {
                    scale = 0.1 // Reset when disappearing
                }
            Text(categoryData.name)
                .foregroundColor(Color(defaultBackgroundColor))
                .font(.custom("jf-openhuninn-2.0", size: 18))
                .scaleEffect(scale) // Apply the same scale effect to the text
                .opacity(scale) // Fade the text in and out with the scale
                .animation(.easeOut(duration: 0.5), value: scale)
        }
    }
}






