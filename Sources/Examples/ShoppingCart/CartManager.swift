//
//  CartManager.swift
//  SweaterShopApp
//
//  Created by Stephanie Diep on 2022-01-03.
//

import Foundation

public class CartManager: ObservableObject {
    @Published private(set) var products: [ShoppingCartItem] = []
    @Published private(set) var total: Int = 0
    
    // Payment-related variables
    let paymentHandler = PaymentHandler()
    @Published var paymentSuccess = false
    
    // Functions to add and remove from cart
    func addToCart(product: ShoppingCartItem) {
        products.append(product)
        total += product.price
    }
    
    func removeFromCart(product: ShoppingCartItem) {
        products = products.filter { $0.id != product.id }
        total -= product.price
    }
    
    // Call the startPayment function from the PaymentHandler. In the completion handler, set the paymentSuccess variable
    func pay() {
        paymentHandler.startPayment(products: products, total: total) { success in
            self.paymentSuccess = success ? true : false
            self.products = []
            self.total = 0
        }
    }
}
