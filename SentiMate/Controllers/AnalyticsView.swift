//
//  AnalyticsView.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/15.
//

import SwiftUI
import Charts

struct WineType: Identifiable {
    let name: String
    let inStock: Int
    let color: Color
    let text: String
    var id: String {
        name
    }
    
    static var all: [WineType] {
        [
            .init(name: "Fortified", inStock: 7, color: .gray, text: "a wine to which a distilled spirit, usually brandy, has been added."),
            .init(name: "Red", inStock: 40, color: .red, text: "a type of wine made from dark-colored grape varieties. The color of the wine can range from intense violet, typical of young wines, through to brick red for mature wines and brown for older red wines."),
            .init(name: "Sparkling", inStock: 8, color: .green, text: "wine with significant levels of carbon dioxide in it, making it fizzy."),
            .init(name: "Rosé", inStock: 5, color: .pink, text: "a type of wine that incorporates some of the color from the grape skins, but not enough to qualify it as a red wine."),
            .init(name: "White", inStock: 82, color: .purple, text: "a wine that is fermented without skin contact. The colour can be straw-yellow, yellow-green, or yellow-gold.")
            
        ]
    }
}


struct DonutChartView: View {
    var wineTypes = WineType.all
    @State private var selectedCount: Int?
    @State private var selectedWineType: WineType?
    var body: some View {
        NavigationStack {
            VStack {
                Chart(wineTypes) { wineType in
                    SectorMark(
                        angle: .value("In Stock", wineType.inStock),
                        innerRadius: .ratio(0.65),
                        outerRadius: selectedWineType?.name == wineType.name ? 175 : 150,
                        angularInset: 1
                    )
                    .foregroundStyle(wineType.color)
                    .cornerRadius(10)
                }
                .chartAngleSelection(value: $selectedCount)
                .chartBackground { _ in
                    if let selectedWineType {
                        VStack {
                            Image(systemName: "wineglass.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color(selectedWineType.color))
                            Text(selectedWineType.name)
                                .font(.largeTitle)
                            Text("In Stock: \(selectedWineType.inStock)")
                        }
                    } else {
                        VStack {
                            Image(systemName: "wineglass.fill")
                                .font(.largeTitle)
                                .foregroundColor(.red)
                            Text("Select a segment")
                        }
                    }
                }
                .frame(height: 350)
                if let selectedWineType {
                    Text(selectedWineType.text)
                }
                Spacer()
            }
            .onChange(of: selectedCount) { oldValue, newValue in
                if let newValue {
                    withAnimation {
                        getSelectedWineType(value: newValue)
                    }
                }
            }
            .padding()
            .navigationTitle("心情圖")
        }
    }
    private func getSelectedWineType(value: Int) {
        var cumulativeTotal = 0
        let wineType = wineTypes.first { wineType in
            cumulativeTotal += wineType.inStock
            if value <= cumulativeTotal {
                selectedWineType = wineType
                return true
            }
            return false
        }
    }
}





