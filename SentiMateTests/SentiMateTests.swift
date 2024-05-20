//
//  SentiMateTests.swift
//  SentiMateTests
//
//  Created by 李芫萱 on 2024/5/20.
//

import XCTest
import Combine
@testable import SentiMate

final class PostDetailVMTests: XCTestCase {
    var sut: PostDetailViewModel!
    var cancellables: Set<AnyCancellable>!
    
    // 整個 class 的 setUp
    // 如果有需要 UserDefault, 也寫假的, 避免動到真實資料
    // Arrange Act Assert
    override func setUp() {
        super.setUp()
        sut = PostDetailViewModel(emotion: "Happy")
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // function 命名一定要是 test 開頭
    // test_VMInit
    func testInit() throws {
        let expectedDateString = DateFormatter.diaryEntryFormatter.string(from: Date())
        let expectedDate = DateFormatter.diaryEntryFormatter.date(from: expectedDateString)
        let viewModelDateString = DateFormatter.diaryEntryFormatter.string(from: sut.selectedDate)
        let viewModelDate = DateFormatter.diaryEntryFormatter.date(from: viewModelDateString)
        // Act & Assert
        XCTAssertEqual(sut.emotion, "Happy")
        XCTAssertEqual(viewModelDate, expectedDate, "Two dates should be equal")
        XCTAssertNil(sut.selectedCategoryIndex)
        XCTAssertEqual(sut.userInput, "")
    }
    
    // test_DataBinding_UserInput_shouldUpdateNewInput
    func testUserInput() throws {
        let expectation = XCTestExpectation(description: "User input should update")
        
        sut.$userInput
            .dropFirst()
            .sink { newUserInput in
                XCTAssertEqual(newUserInput, "New input")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.userInput = "New input"
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // (optional)測 MockManager -> mockData, error handle
    
    // 每個 funtion 開始前後都 setUp tearDown
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
