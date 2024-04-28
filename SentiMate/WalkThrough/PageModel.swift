//
//  PageModel.swift
//  SentiMate
//
//  Created by 李芫萱 on 2024/4/28.
//

import Foundation

struct Page: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var description: String
    var imageUrl: String
    var tag: Int
    
    static var samplePage = Page(name: "Title Example", description: "This is a sample description for the purpose of debugging", imageUrl: "testImage", tag: 0)
    
    static var samplePages: [Page] = [
        Page(name: "Welcome to Default App!", description: "The best app to get stuff done on an app.", imageUrl: "testImage", tag: 0),
        Page(name: "Meet new people!", description: "The perfect place to meet new people so you can meet new people!", imageUrl: "testImage", tag: 1),
        Page(name: "Edit your face", description: "Don't like your face? Well then edit your face with our edit-face tool!", imageUrl: "testImage", tag: 2),
    ]
}
