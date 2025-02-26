//
//  IAPManager.swift
//  DevioxLinker
//
//  Created by DevioxLinker on 2025/2/26.
//

import StoreKit

class DevioxIAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = DevioxIAPManager()
    
    private let tokenProductID = "com.nirav.DevioxLinker.tokens.100" // Replace with your actual product ID
    private var productsRequest: SKProductsRequest?
    private var completionHandler: ((Bool) -> Void)?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func presentTokenPurchaseOptions(from viewController: UIViewController) {
        if SKPaymentQueue.canMakePayments() {
            let productIdentifiers = Set([tokenProductID])
            productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
            productsRequest?.delegate = self
            productsRequest?.start()
        } else {
            showAlert(on: viewController, message: "In-App Purchases are disabled")
        }
    }
    
    // MARK: - SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        guard let product = response.products.first else {
            print("No products found")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                // Purchase was successful
                DevioxTokenManager.shared.addTokens(100)
                SKPaymentQueue.default().finishTransaction(transaction)
                NotificationCenter.default.post(name: NSNotification.Name("TokensPurchased"), object: nil)
                
            case .failed:
                print("Purchase failed: \(String(describing: transaction.error))")
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .restored:
                DevioxTokenManager.shared.addTokens(100)
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func showAlert(on viewController: UIViewController, message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
}
