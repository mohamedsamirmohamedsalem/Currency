//
//  HistoryModel.swift
//  Currency
//
//  Created by Mohamed Samir on 29/09/2022.
//

import Foundation


class HistoryModel: ObservableObject , Identifiable{
    @Published  var history: [[CurHistoryEntity]]
    @Published var id: UUID
    
    init( history: [[CurHistoryEntity]],id: UUID = UUID()) {
        self.history = history
        self.id = id
    }
    
}
