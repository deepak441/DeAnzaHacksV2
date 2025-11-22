import SwiftUI


@main
struct SecondServeApp: App {
    @StateObject private var userViewModel = UserViewModel(user: SampleData.user)
    @StateObject private var itemsViewModel = ItemsViewModel(items: SampleData.items(ownerId: SampleData.user.id))
    @StateObject private var cartViewModel = CartViewModel()
    @StateObject private var tabRouter = TabRouter()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(itemsViewModel)
                .environmentObject(cartViewModel)
                .environmentObject(tabRouter)
        }
    }
}
