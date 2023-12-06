//
//  EventsListViewModel.swift
//  Marvel
//
//  Created by Cristina Amoedo Fragueiro on 1/12/23.
//

import Foundation
 
class EventsListViewModel {
    var view: EventsListViewController
    
    private let eventsListCoordinator: EventsListCoordinator

    init(eventsListCoordinator: EventsListCoordinator,
         view: EventsListViewController) {
        self.eventsListCoordinator = eventsListCoordinator
        self.view = view
        
    }
}
