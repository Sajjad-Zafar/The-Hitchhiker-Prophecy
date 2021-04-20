//
//  HomeSceneInteractorTestCase.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Muhammad Sajjad Zafar on 20/04/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import XCTest
@testable import The_Hitchhiker_Prophecy

class HomeSceneInteractorTestCase: XCTestCase {

    var homeSceneInteractor: HomeSceneInteractor!
    var homeScenePresenter: TestHomeScenePresenter!
    private var expectation: XCTestExpectation!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        homeScenePresenter = TestHomeScenePresenter()
        homeSceneInteractor = HomeSceneInteractor(worker: HomeSearchWorker(), presenter: homeScenePresenter)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.homeScenePresenter = nil
        self.homeSceneInteractor = nil
    }

    //This test case will hit the api and check the results array are there
    func test_Interactor_Get_Characters() {
        self.expectation = expectation(description: "Get the list of characters successfully.")
        homeScenePresenter.completion = { (output, error) in
            self.expectation.fulfill()
            guard let results = output?.data.results else {
                XCTFail()
                return
            }
            XCTAssert(results.count > 0)
            XCTAssertNil(error)
        }
        homeSceneInteractor.fetchCharacters()
        
        wait(for: [self.expectation], timeout: 10)
        
        
    }
    
    // This test case will be pass when server is not responding
    func test_Interactor_Fail_To_Get_Characters() {
        self.expectation = expectation(description: "server is not responding.")
        homeScenePresenter.completion = { (_, error) in
            self.expectation.fulfill()
            XCTAssertNotNil(error)
        }
        homeSceneInteractor.fetchCharacters()
        wait(for: [self.expectation], timeout: 10)
        
    }
}

extension HomeSceneInteractorTestCase {
    class TestHomeScenePresenter: HomeScenePresentationLogic {
        var displayView: HomeSceneDisplayView?
        
        var completion: ((Characters.Search.Output?, NetworkError?) -> ())?
        
        func presentCharacters(_ response: HomeScene.Search.Response) {
            switch response {
                case .success(let output):
                    completion?(output, nil)
                case .failure(let error):
                    completion?(nil, error)
            }
        }
        
        
    }
}
