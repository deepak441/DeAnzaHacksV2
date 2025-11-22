import SwiftUI
import Combine

@MainActor
final class TabRouter: ObservableObject {
    enum Tab: Hashable {
        case home
        case add
        case profile
    }

    @Published var selectedTab: Tab = .home
}
