//
//  HistoriesListViewModel.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//


import Foundation
 
class StoriesListViewModel {
    var view: StoriesListViewController
    
    private let historiesListCoordinator: StoriesListCoordinator

    init(historiesListCoordinator: StoriesListCoordinator,
         view: StoriesListViewController) {
        self.historiesListCoordinator = historiesListCoordinator
        self.view = view
        
    }
}
