//
//  StoreManager.swift
//  YBlock
//
//  Created by Gabons on 14/11/25.

import StoreKit
import SwiftUI

@Observable
final class StoreManager {
    static let shared = StoreManager()
    
    private let monthlyProductID = "com.fedora.YBlock.premium.monthly"
    private let yearlyProductID =  "com.fedora.YBlock.premium.annual"

    
    @MainActor var monthlyProduct: Product?
    @MainActor var yearlyProduct: Product?
    @MainActor var isPremium: Bool = false
    @MainActor var isLoading = false
    
    private var updateListenerTask: Task<Void, Never>?
    
    init() {
        updateListenerTask = Task {
            await self.listenForTransactions()
        }
        
        Task {
            await loadProducts()
            await updateSubscriptionStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    @MainActor
    func loadProducts() async {
        do {
            print("🔍 Requesting products: [\(monthlyProductID), \(yearlyProductID)]")
            let products = try await Product.products(for: [monthlyProductID, yearlyProductID])
            print("📦 Products returned: \(products.count)")
            
            for product in products {
                if product.id == monthlyProductID {
                    monthlyProduct = product
                    print("✅ Loaded monthly: \(product.displayName) - \(product.displayPrice)")
                } else if product.id == yearlyProductID {
                    yearlyProduct = product
                    print("✅ Loaded yearly: \(product.displayName) - \(product.displayPrice)")
                }
            }
        } catch {
            print("❌ Failed to load products: \(error)")
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateSubscriptionStatus()
            return true
            
        case .userCancelled, .pending:
            return false
            
        @unknown default:
            return false
        }
    }
    
    @MainActor
    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updateSubscriptionStatus()
        } catch {
            print("❌ Failed to restore: \(error)")
        }
    }
    
    @MainActor
    func updateSubscriptionStatus() async {
        var isActive = false
        
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result {
                // both product IDs
                if transaction.productID == monthlyProductID ||
                   transaction.productID == yearlyProductID {
                    isActive = true
                    break
                }
            }
        }
        
        isPremium = isActive
        UserDefaults.standard.set(isActive, forKey: "isPremium")
    }
    
    private func listenForTransactions() async {
        for await result in Transaction.updates {
            if case .verified(let transaction) = result {
                await transaction.finish()
                await updateSubscriptionStatus()
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    enum StoreError: Error {
        case failedVerification
    }
}


