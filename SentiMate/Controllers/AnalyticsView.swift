//
//  AnalyticsView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import SwiftUI
import Charts

struct DonutChartView: View {
    var emotionTypes: [EmotionType]
    @State private var selectedCount: Int?
    @State private var selectedEmotionType: EmotionType?
    
    var body: some View {
        NavigationStack {
            VStack {
                Chart(emotionTypes) { emotionType in
                    SectorMark(
                        angle: .value("Count", emotionType.count),
                        innerRadius: .ratio(0.65),
                        outerRadius: selectedEmotionType?.name == emotionType.name ? 175 : 150,
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
                            Text("Count: \(selectedEmotionType.count)")
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
                .frame(height: 350)
                if let selectedEmotionType {
                    Text(selectedEmotionType.name)
                }
                Spacer()
            }
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelectedEmotionType(value: newValue)
                    }
                }
            }
            .padding()
            .navigationTitle("心情圖")
        }
    }
    private func getSelectedEmotionType(value: Int) {
        var cumulativeTotal = 0
        let emotionType = emotionTypes.first { emotionType in
            cumulativeTotal += emotionType.count
            if value <= cumulativeTotal {
                selectedEmotionType = emotionType
                return true
            }
            return false
        }
    }
}





