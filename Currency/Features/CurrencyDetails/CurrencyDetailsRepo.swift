

protocol CurrencyDetailsRepoProtocol: AnyObject {
    
    var networkManager: NetworkManagerProtocol?   { get }
    var databaseManager: DatabaseManagerProtocol? { get }
}

class CurrencyDetailsRepo: CurrencyDetailsRepoProtocol{
    
    var networkManager: NetworkManagerProtocol?
    var databaseManager: DatabaseManagerProtocol?
    
    init(networkManager: NetworkManagerProtocol?,databaseManager: DatabaseManagerProtocol?) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }
    
}


