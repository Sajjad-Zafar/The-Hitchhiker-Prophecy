//
//  HomeScenePresenterTestCase.swift
//  The Hitchhiker ProphecyTests
//
//  Created by Muhammad Sajjad Zafar on 20/04/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import XCTest
@testable import The_Hitchhiker_Prophecy

class HomeScenePresenterTestCase: XCTestCase {
    
    var homeScreenPresentationLogic: HomeScenePresentationLogic!
    var testHomeSceneInteractor: TestHomeSceneInteractor!
    var testHomeSceneDisplayView: TestHomeSceneDisplayView!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.testHomeSceneDisplayView = TestHomeSceneDisplayView()
        self.homeScreenPresentationLogic = HomeScenePresneter(displayView: testHomeSceneDisplayView)
        self.testHomeSceneInteractor = TestHomeSceneInteractor(worker: HomeSearchWorker(), presenter: homeScreenPresentationLogic)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.testHomeSceneDisplayView = nil
        self.homeScreenPresentationLogic = nil
        self.testHomeSceneInteractor = nil
    }

    func test_Presenter_Show_Results() {
        testHomeSceneInteractor.fetchCharacters()
        XCTAssert(testHomeSceneDisplayView.viewModel.count > 0)
    }
    
    func test_Presenter_Failed_To_Fetch_Results() {
        testHomeSceneInteractor.fileName = "MarvelName"
        testHomeSceneInteractor.fetchCharacters()
        XCTAssertTrue((testHomeSceneDisplayView.failedToFetchCharacters))
    }
    
    func testPresenterIfDataIsNotAvailable() {
        testHomeSceneInteractor.fetchCharacters()
    }
}

extension HomeScenePresenterTestCase {
    class TestHomeSceneInteractor: HomeSceneBusinessLogic {
        var worker: HomeWorkerType
        var presenter: HomeScenePresentationLogic
        var fileName: String = "MarvelMockData"
        
        init(worker: HomeWorkerType, presenter: HomeScenePresentationLogic) {
            self.worker = worker
            self.presenter = presenter
        }
        
        func fetchCharacters() {
            guard let path = Bundle.main.path(forResource: fileName, ofType: ".json") else {
                self.presenter.presentCharacters(.failure(.unknown))
                return
            }
            let data = try? Data(contentsOf: URL(fileURLWithPath: path))
            if let json = try? JSONDecoder().decode(Characters.Search.Output.self, from: data ?? Data()) {
                self.presenter.presentCharacters(.success(json))
            } else {
                self.presenter.presentCharacters(.failure(.unknown))
            }
        }
    }
    
    class TestHomeSceneDisplayView: HomeSceneDisplayView {
        var interactor: HomeSceneBusinessLogic?
        
        var failedToFetchCharacters: Bool = false
        var viewModel = [HomeScene.Search.ViewModel]()
        
        var router: HomeSceneRoutingLogic?
        
        func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
            self.viewModel = viewModel
            self.failedToFetchCharacters = false
        }
        
        func failedToFetchCharacters(error: Error) {
            self.failedToFetchCharacters = true
        }
        
        
    }
}


