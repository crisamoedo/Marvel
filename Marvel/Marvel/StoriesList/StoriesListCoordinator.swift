//
//  HistoriesListCoordinator.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//


import UIKit

class StoriesListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let historiesListViewController = StoriesListViewController()
        let historiesListViewModel = StoriesListViewModel(historiesListCoordinator: self, view: historiesListViewController)
        historiesListViewController.viewModel = historiesListViewModel
        
        return historiesListViewController
    }
}
