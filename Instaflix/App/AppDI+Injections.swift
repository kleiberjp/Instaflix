//
//  AppDI+Injections.swift
//  Instaflix
//
//  Created by Kleiber Perez on 12/09/24.
//

import Foundation

extension DIContainer {
    
    func registerInjections() {
        
        //Core
        register(type: PersistanceDBManager.self, component: CoreDataManager())
        
        //MediaItems
        register(type: MediaItemsRemoteProtocol.self, component: MediaItemRemote())
        register(type: MediaItemsAPIRepositoryProtocol.self, component: MediaItemAPIRepository())
        register(type: MediaItemsDBRepositoryProtocol.self, component: MediaItemDBRepository())
        register(type: MediaItemsUseCaseProtocol.self, component: MediaItemsUseCase())        
    }
}
