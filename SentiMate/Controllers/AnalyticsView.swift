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
        NavigationStack {
            VStack {
                Picker("Time Period", selection: $selectedTimePeriod) {
                                    ForEach(TimePeriod.allCases, id: \.self) { period in
                                        Text(period.rawValue).tag(period)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                
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
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color(selectedEmotionType.color))
                            Text(selectedEmotionType.name)
                                .font(.largeTitle)
                            Text("\(selectedEmotionType.percentage) %")
                        }
                    } else {
                        VStack {
                            Image(systemName: "heart.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("Select a segment")
                        }
                    }
                }
                .frame(height: 300)
                if let selectedEmotionType {
                    Text("讓我感到\(selectedEmotionType.name)的是")
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
                emotionTypes = DiaryManager.shared.getEmotionTypes(forPeriod: newPeriod)
            }
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    withAnimation {
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
            .navigationTitle("心情圖")
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
    
    var body: some View {
        let scaledCount = sqrt(CGFloat(categoryData.count) / CGFloat(maxCount))
               // Then, apply a multiplier to get a usable size
               let diameter = scaledCount * 100
        
        ZStack {
            Circle()
                .frame(width: diameter, height: diameter)
                .foregroundColor(.gray)  
            Text(categoryData.name)
                .foregroundColor(.white)
        }
    }
}





