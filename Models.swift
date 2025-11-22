import Foundation

struct PrivacySettings {
    var maskAddress: Bool
    var inAppMessagingOnly: Bool
    var aiDataOptIn: Bool
}

struct Consents {
    var aiDataProgram: Bool
    var createdAt: Date
}

struct User {
    let id: UUID
    var name: String
    var email: String?
    var phone: String?
    var radiusMiles: Double?
    var points: Int
    var dietaryPreferences: [String]
    var privacySettings: PrivacySettings
    var consents: Consents
}

enum ItemStatus: String, CaseIterable, Identifiable {
    case pendingApproval
    case active
    case completed

    var id: String { rawValue }
    var displayName: String {
        switch self {
        case .pendingApproval: return "Pending"
        case .active: return "Active"
        case .completed: return "Completed"
        }
    }
}

struct Item: Identifiable, Hashable {
    let id: UUID
    let ownerId: UUID
    var name: String
    var category: String
    var donation: Bool
    var sealed: Bool
    var expiryDate: Date
    var description: String
    var photoURLs: [URL]?
    var priceUSD: Double?
    var locationText: String
    var status: ItemStatus
    var createdAt: Date
}

struct CartItem: Identifiable {
    let id = UUID()
    let item: Item
    var quantity: Int
}
