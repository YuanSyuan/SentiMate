//
//  TipKit.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/12.
//

import TipKit
import SwiftUI
import UIKit

struct ChartTip: Tip {
    var title: Text {
        Text("試著長按圖表吧")
            .font(.custom("jf-openhuninn-2.0", size: 16))
    }
    var message: Text? {
        Text("查看情緒佔比及影響情緒的類別")
            .font(.custom("jf-openhuninn-2.0", size: 16))
    }
    var image: Image? {
        Image("Hand")
    }
}

struct EmotionFeatureTip: Tip {
    var title: Text {
        Text("Emoji 手勢小百科")
    }

    var message: Text? {
        Text("01. 滑動可旋轉 Emoji\n02. 兩指觸碰可拖曳 Emoji\n03. 兩指縮放可改變 Emoji 大小\n04. 連點兩下讓 Emoji 轉回正面\n05. 長按叫出 Emoji 手勢小百科")
    }

    var image: Image? {
        Image("Hand")
    }
}
