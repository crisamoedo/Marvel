//
//  EventsListCoordinator.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//


import UIKit

class EventsListCoordinator {
    weak var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(){
        navigationController?.pushViewController(build(), animated: true)
    }
    
    func build() -> UIViewController {
        let eventsListViewController = EventsListViewController()
        let eventsListViewModel = EventsListViewModel(eventsListCoordinator: self, view: eventsListViewController)
        eventsListViewController.viewModel = eventsListViewModel
        
        return eventsListViewController
    }
}
