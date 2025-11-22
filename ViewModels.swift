import Foundation
import SwiftUI
import Combine

@MainActor
final class UserViewModel: ObservableObject {
    @Published var currentUser: User

    init(user: User) {
        self.currentUser = user
    }

    func updateProfile(name: String, email: String?, phone: String?, radiusMiles: Double?) {
        currentUser.name = name
        currentUser.email = email
        currentUser.phone = phone
        currentUser.radiusMiles = radiusMiles
    }

    func updatePreferences(_ preferences: [String]) {
        currentUser.dietaryPreferences = preferences
    }

    func updatePrivacy(_ privacy: PrivacySettings, consents: Consents) {
        currentUser.privacySettings = privacy
        currentUser.consents = consents
    }

    func addPoints(_ points: Int) {
        currentUser.points += points
    }
}

@MainActor
final class ItemsViewModel: ObservableObject {
    @Published var items: [Item]

    init(items: [Item] = []) {
        self.items = items
    }

    func addItem(_ item: Item) {
        items.append(item)
    }

    func itemsForUser(_ userId: UUID) -> [Item] {
        items.filter { $0.ownerId == userId }
    }

    var activeItems: [Item] {
        items.filter { $0.status == .active || $0.status == .pendingApproval }
    }
}

@MainActor
final class CartViewModel: ObservableObject {
    @Published var items: [CartItem] = []

    func addToCart(_ item: Item) {
        if let index = items.firstIndex(where: { $0.item.id == item.id }) {
            items[index].quantity += 1
        } else {
            items.append(CartItem(item: item, quantity: 1))
        }
    }

    func removeFromCart(_ item: Item) {
        if let index = items.firstIndex(where: { $0.item.id == item.id }) {
            items.remove(at: index)
        }
    }

    func clearCart() {
        items.removeAll()
    }

    var totalPrice: Double {
        items.reduce(0) { partialResult, cartItem in
            let price = cartItem.item.priceUSD ?? 0
            return partialResult + (price * Double(cartItem.quantity))
        }
    }
}
