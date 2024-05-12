//
//  TipKit.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/5/12.
//

import TipKit
import SwiftUI

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
            // to be modified
            Image("Hand")
               
    }
}
