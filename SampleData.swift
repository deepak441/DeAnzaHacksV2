import Foundation

struct SampleData {
    static let user = User(
        id: UUID(),
        name: "Jamie Lee",
        email: "jamie@example.com",
        phone: "555-123-4567",
        radiusMiles: 15,
        points: 42,
        dietaryPreferences: ["Vegetarian", "Gluten-free"],
        privacySettings: PrivacySettings(
            maskAddress: true,
            inAppMessagingOnly: true,
            aiDataOptIn: false
        ),
        consents: Consents(
            aiDataProgram: false,
            createdAt: Date()
        )
    )

    static func items(ownerId: UUID) -> [Item] {
        [
            Item(
                id: UUID(),
                ownerId: ownerId,
                name: "Sourdough Loaf",
                category: "Bread",
                donation: false,
                sealed: true,
                expiryDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date(),
                description: "Freshly baked sourdough, perfect for sandwiches.",
                photoURLs: nil,
                priceUSD: 4.50,
                locationText: "San Jose, CA",
                status: .active,
                createdAt: Date()
            ),
            Item(
                id: UUID(),
                ownerId: ownerId,
                name: "Veggie Box",
                category: "Produce",
                donation: true,
                sealed: false,
                expiryDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                description: "Mixed veggies from this week's CSA box.",
                photoURLs: nil,
                priceUSD: nil,
                locationText: "Cupertino, CA",
                status: .active,
                createdAt: Date()
            ),
            Item(
                id: UUID(),
                ownerId: UUID(),
                name: "Pasta Salad",
                category: "Prepared",
                donation: false,
                sealed: true,
                expiryDate: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date(),
                description: "Large tray of veggie pasta salad, great for potlucks.",
                photoURLs: nil,
                priceUSD: 10.0,
                locationText: "Sunnyvale, CA",
                status: .pendingApproval,
                createdAt: Date()
            ),
            Item(
                id: UUID(),
                ownerId: UUID(),
                name: "Bagels Pack",
                category: "Bread",
                donation: true,
                sealed: false,
                expiryDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                description: "Half dozen bagels, assorted flavors.",
                photoURLs: nil,
                priceUSD: nil,
                locationText: "Mountain View, CA",
                status: .active,
                createdAt: Date()
            )
        ]
    }
}
