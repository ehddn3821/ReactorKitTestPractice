//
//  ReactorKitTestPracticeTests.swift
//  ReactorKitTestPracticeTests
//
//  Created by 앱지 Appg on 2022/09/30.
//

import XCTest
import RxSwift
import RxCocoa
@testable import ReactorKitTestPractice

final class ReactorKitTestPracticeTests: XCTestCase {
    
//    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var disposeBag = DisposeBag()

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
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testFetchQuery() {
        let reactor = ViewReactor()
        
        let expectation = XCTestExpectation(description: "fetchQuery")
        reactor.state.map(\.repos)
            .filter { !$0.isEmpty }
            .subscribe(onNext: { repos in
                print("repos: \(repos)")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        reactor.action.onNext(.updateQuery("snapkit"))
        
        wait(for: [expectation], timeout: 5.0)
    }
}
