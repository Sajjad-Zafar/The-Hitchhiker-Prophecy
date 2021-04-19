//
//  HomeScenePresenter.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/13/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import Foundation

class HomeScenePresneter: HomeScenePresentationLogic {
    weak var displayView: HomeSceneDisplayView?
    
    init(displayView: HomeSceneDisplayView) {
        self.displayView = displayView
    }
    
    func presentCharacters(_ response: HomeScene.Search.Response) {
        // TODO: Implement
        switch response {
            case .success(let output):
                var viewModel = [HomeScene.Search.ViewModel]()
                for char in output.data.results {
                    let imageURL =  "\(char.thumbnail.path)/\(CharacterDetailsScene.Constants.ImageSize.Standard.Fantastic.rawValue).\(char.thumbnail.thumbnailExtension)"
                    let viewModelItem = HomeScene.Search.ViewModel(name: char.name, desc: char.resultDescription, imageUrl: imageURL, comics: "", series: "", stories: "", events: "")
                    viewModel.append(viewModelItem)
                }
                self.displayView?.didFetchCharacters(viewModel: viewModel)
            case .failure(let error):
                self.displayView?.failedToFetchCharacters(error: error)
        }
    }
}
