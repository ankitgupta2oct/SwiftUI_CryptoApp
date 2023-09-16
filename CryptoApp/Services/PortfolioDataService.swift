//
//  PortfolioDataService.swift
//  CryptoApp
//
//  Created by apple on 02/08/23.
//

import Foundation
import CoreData

class PortfolioDataService {
    
    @Published var portfolioData: [PortfolioEntity] = []
    
    private let cointainer: NSPersistentContainer
    private let cointainerName = "PortfolioCointainer"
    private let entityName = "PortfolioEntity"
    
    static let instance = PortfolioDataService()
    
    private init() {
        cointainer = NSPersistentContainer(name: cointainerName)
        cointainer.loadPersistentStores { _, error in
            if let error = error {
                print("Error while loading cointainer \(error.localizedDescription)")
            } else {
                self.fetchPortfolio()
            }
        }
    }
    
    // MARK: Public methods
    func updatePortfolio(coinModel: CoinModel, amount: Double) {
        if let entity = portfolioData.first(where: {$0.coinId == coinModel.id}) {
            if (amount > 0) {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coinModel: coinModel, amount: amount)
        }
    }
    
    func fetchPortfolio() {
        let requst = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            portfolioData = try cointainer.viewContext.fetch(requst)
        } catch(let error) {
            print("Error while fetching \(error.localizedDescription)")
        }
    }
    
    // MARK: Private methods
    private func add(coinModel: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: cointainer.viewContext)
        entity.coinId = coinModel.id
        entity.amount = amount
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, amount: Double) {
        entity.amount = amount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        cointainer.viewContext.delete(entity)
        applyChanges()
    }
    
    private func applyChanges() {
        saveContainer()
        fetchPortfolio()
    }
    
    private func saveContainer() {
        do {
            try cointainer.viewContext.save()
        } catch(let error) {
            print("Error while saving \(error.localizedDescription)")
        }
    }
}
