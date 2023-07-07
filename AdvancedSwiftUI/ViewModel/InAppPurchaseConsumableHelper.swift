//
//  InAppPurchaseConsumableHelper.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import StoreKit
import SwiftUI

/// A helper class for handling consumable in-app purchases.
class InAppPurchaseConsumableHelper: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    
    /// A boolean property indicating whether the content is unlocked.
    @AppStorage("isContentUnlocked") var isContentUnlocked: Bool = false
    
    /// An optional string property for storing the failed transaction message.
    @AppStorage("failedTransactionMessage") var failedTransactionMessage: String?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    /// Fetches the available products for purchase.
    ///
    /// - Parameter productIdentifiers: A set of product identifiers to fetch.
    func fetchProducts(productIdentifiers: Set<String>) {
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    /// Initiates the purchase of a product.
    ///
    /// - Parameter product: The product to purchase.
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                // Transaction is being processed
                break
            case .purchased, .restored:
                // Transaction completed successfully
                complete(transaction: transaction)
            case .failed:
                // Transaction failed
                fail(transaction: transaction)
            case .deferred:
                // Transaction is in the queue, but its final status is pending external action
                break
            @unknown default:
                break
            }
        }
    }
    
    private func complete(transaction: SKPaymentTransaction) {
        // Process the completed transaction, e.g., provide in-game currency or unlock features
        // You can use the transaction.transactionIdentifier or transaction.payment.productIdentifier to identify the purchased product
        
        // Update the consumable item count or unlock features
        // For example: increment a user's in-game currency balance
        
        isContentUnlocked = true
        
        // Finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        // Handle the failed transaction
        // Optionally, you can provide feedback to the user about the failure
        
        failedTransactionMessage = "Transaction failed."
        
        // Finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}


//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var purchaseHelper = InAppPurchaseConsumableHelper()
//    
//    var body: some View {
//        VStack {
//            // Display the available products
//            List(purchaseHelper.products, id: \.productIdentifier) { product in
//                Text("\(product.localizedTitle): \(product.localizedPrice ?? "")")
//            }
//            
//            // Button to initiate the purchase
//            Button("Purchase") {
//                if let product = purchaseHelper.products.first {
//                    purchaseHelper.purchase(product: product)
//                }
//            }
//        }
//        .onAppear {
//            // Fetch the available products when the view appears
//            purchaseHelper.fetchProducts(productIdentifiers: ["your_product_identifier"])
//        }
//    }
//}
