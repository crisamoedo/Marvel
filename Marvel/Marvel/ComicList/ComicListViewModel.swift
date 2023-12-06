//
//  ItemsListViewModel.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 28/11/23.
//

import Foundation
 
class ComicListViewModel {
    var view: ComicListViewController
    
    private let comicListCoordinator: ComicListCoordinator

    init(comicListCoordinator: ComicListCoordinator,
         view: ComicListViewController) {
        self.comicListCoordinator = comicListCoordinator
        self.view = view
        
    }
}
