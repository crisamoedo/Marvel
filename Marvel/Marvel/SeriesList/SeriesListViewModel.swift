//
//  SeriesListViewModel.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//


import Foundation
 
class SeriesListViewModel {
    var view: SeriesListViewController
    
    private let seriesListCoordinator: SeriesListCoordinator

    init(seriesListCoordinator: SeriesListCoordinator,
         view: SeriesListViewController) {
        self.seriesListCoordinator = seriesListCoordinator
        self.view = view
        
    }
}
