//
//  HomeSceneCollectionManager.swift
//  The Hitchhiker Prophecy
//
//  Created by Muhammad Sajjad Zafar on 18/04/2021.
//  Copyright © 2021 SWVL. All rights reserved.
//

import Foundation
import UIKit

class HomeSceneCollectionManager: NSObject {
    
    var homeSceneCollectionManagerDelegate: HomeSceneCollectionManagerDelegate?
    
    let viewModel: [HomeScene.Search.ViewModel]
    var layout: Layout
    
    init(viewModel: [HomeScene.Search.ViewModel], layout: Layout) {
        self.viewModel = viewModel
        self.layout = layout
    }
}

extension HomeSceneCollectionManager: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCharacterCollectionViewCell.reusableIdentifier, for: indexPath) as? HomeCharacterCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: self.viewModel[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homeSceneCollectionManagerDelegate?.didSelectCharacter(character: self.viewModel[indexPath.row], atIndexPath: indexPath)
    }
}

extension HomeSceneCollectionManager: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width = collectionView.frame.width
        var height = collectionView.frame.height
        switch self.layout {
            case .list:
                width = collectionView.frame.width - 20
                height = 180
            case .cards:
                width = collectionView.frame.width - 40
                height = collectionView.frame.height * 0.8
        }
        return CGSize(width: width, height: height)
    }
}
