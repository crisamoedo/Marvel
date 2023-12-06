//
//  ItemsListUseCase.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 28/11/23.
//

import Foundation

class ItemsListUseCase {
    var itemsLitsRepository: ItemsListRepository
    
    init(itemsListRepository:ItemsListRepository) {
        self.itemsLitsRepository = itemsListRepository
    }
    
}
