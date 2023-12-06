//
//  SeriesListCoordinator.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//


import UIKit

class SeriesListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let seriesListViewController = SeriesListViewController()
        let seriesListViewModel = SeriesListViewModel(seriesListCoordinator: self, view: seriesListViewController)
        seriesListViewController.viewModel = seriesListViewModel
        
        return seriesListViewController
    }
}
