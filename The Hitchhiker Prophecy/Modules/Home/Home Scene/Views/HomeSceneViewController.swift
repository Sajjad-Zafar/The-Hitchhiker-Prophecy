//
//  HomeSceneViewController.swift
//  The Hitchhiker Prophecy
//
//  Created by Mohamed Matloub on 6/10/20.
//  Copyright © 2020 SWVL. All rights reserved.
//

import UIKit

enum Layout {
    case cards
    case list
}

class HomeSceneViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    
    private var homeSceneCollectionManager: HomeSceneCollectionManager?
    private var layout: Layout = .list
    
    var interactor: HomeSceneBusinessLogic?
    var router: HomeSceneRoutingLogic?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(HomeCharacterCollectionViewCell.nib, forCellWithReuseIdentifier: HomeCharacterCollectionViewCell.reusableIdentifier)
        interactor?.fetchCharacters()
        setupNavigationItem()
    }
    
    // MARK: - Navigation Item
    func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change Layout", style: .plain, target: self, action: #selector(changeLayoutTapped))
    }
    
    // MARK: - Collection View Layout Action
    @objc func changeLayoutTapped(_ sender: Any) {
        if self.layout == .list {
            self.layout = .cards
            collectionViewFlowLayout.scrollDirection = .horizontal
        } else {
            self.layout = .list
            collectionViewFlowLayout.scrollDirection = .vertical
        }
        homeSceneCollectionManager?.layout = layout
        self.collectionView.reloadData()
    }
}

extension HomeSceneViewController: HomeSceneDisplayView {
    func didFetchCharacters(viewModel: [HomeScene.Search.ViewModel]) {
        // TODO: Implement
        homeSceneCollectionManager = HomeSceneCollectionManager(viewModel: viewModel, layout: self.layout)
        collectionView.delegate = self.homeSceneCollectionManager
        collectionView.dataSource = self.homeSceneCollectionManager
        collectionView.reloadData()
    }
    
    func failedToFetchCharacters(error: Error) {
        // TODO: Implement
    }
}
