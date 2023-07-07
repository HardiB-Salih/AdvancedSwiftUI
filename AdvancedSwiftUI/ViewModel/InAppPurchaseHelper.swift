//
//  InAppPurchaseHelper.swift
//  AdvancedSwiftUI
//
//  Created by HardiB.Salih on 7/6/23.
//

import StoreKit
import SwiftUI

class InAppPurchaseHelper: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var products: [SKProduct] = []
    
    @AppStorage("isSubscribed") var isSubscribed: Bool = false
    @AppStorage("subscriptionExpiryDate") var subscriptionExpiryDate: TimeInterval = 0
    @AppStorage("failedTransactionMessage") var failedTransactionMessage: String?
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func fetchProducts(productIdentifiers: Set<String>) {
        let productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest.delegate = self
        productsRequest.start()
    }
    
    func purchase(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func cancelSubscription() {
        // TODO: Implement the cancellation logic based on your backend or server-side integration.
        // This typically involves communicating with your server to cancel the subscription for the user.
        // You may also need to update the UI and user's subscription status accordingly.
        
        isSubscribed = false
        subscriptionExpiryDate = 0
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
        let productIdentifier = transaction.payment.productIdentifier

        // Process the completed transaction based on the product identifier
        if productIdentifier == "your_subscription_product_identifier" {
            handleSubscriptionPurchase()
        }

        // Finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
//    private func complete(transaction: SKPaymentTransaction) {
//        let productIdentifier = transaction.payment.productIdentifier
//
//        // Process the completed transaction based on the product identifier
//        switch productIdentifier {
//        case "your_monthly_subscription_product_identifier":
//            handleMonthlySubscriptionPurchase()
//        case "your_yearly_subscription_product_identifier":
//            handleYearlySubscriptionPurchase()
//        case "your_weekly_subscription_product_identifier":
//            handleWeeklySubscriptionPurchase()
//        default:
//            break
//        }
//
//        // Finish the transaction
//        SKPaymentQueue.default().finishTransaction(transaction)
//    }



    
    private func fail(transaction: SKPaymentTransaction) {
        failedTransactionMessage = "Transaction failed."
        
        // Finish the transaction
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleSubscriptionPurchase() {
        // TODO: Implement the logic to handle the subscription purchase.
        // Typically, you would validate the receipt and update the user's subscription status and expiry date.
        // You may also need to communicate with your backend or server to verify the receipt and process the subscription.
        
        isSubscribed = true
        
        // Set the subscription expiry date based on your implementation
        // For example, you can set it to one month from the current date
        subscriptionExpiryDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())?.timeIntervalSinceReferenceDate ?? 0
//        subscriptionExpiryDate = Calendar.current.date(byAdding: .weekOfMonth, value: 1, to: Date())?.timeIntervalSinceReferenceDate ?? 0
//        subscriptionExpiryDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())?.timeIntervalSinceReferenceDate ?? 0
    }
}


//import SwiftUI
//
//struct ContentView: View {
//    @StateObject private var purchaseHelper = InAppPurchaseHelper()
//
//    var body: some View {
//        VStack {
//            // Display the available subscription products
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
//
//            // Button to restore purchases
//            Button("Restore Purchases") {
//                purchaseHelper.restorePurchases()
//            }
//
//            // Button to cancel subscription
//            Button("Cancel Subscription") {
//                purchaseHelper.cancelSubscription()
//            }
//
//            // Display the subscription status
//            Text("Subscription Status: \(purchaseHelper.isSubscribed ? "Subscribed" : "Not Subscribed")")
//
//            // Display the subscription expiry date
//            if let expiryDate = purchaseHelper.subscriptionExpiryDate {
//                Text("Subscription Expiry Date: \(expiryDate)")
//            }
//
//            // Display the failed transaction message, if any
//            if let message = purchaseHelper.failedTransactionMessage {
//                Text(message)
//            }
//        }
//        .onAppear {
//            // Fetch the available subscription products when the view appears
//            purchaseHelper.fetchProducts(productIdentifiers: ["your_subscription_product_identifier"])
//        }
//    }
//}
