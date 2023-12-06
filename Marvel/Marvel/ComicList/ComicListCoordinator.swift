//
//  ItemsListCoordinator.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 28/11/23.
//

import UIKit

class ComicListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let comicListViewController = ComicListViewController()
        let comicListViewModel = ComicListViewModel(comicListCoordinator: self, view: comicListViewController)
        comicListViewController.viewModel = comicListViewModel
        
        return comicListViewController
    }
}
