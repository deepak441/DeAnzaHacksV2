import SwiftUI

struct ContentView: View {
	@EnvironmentObject private var tabRouter: TabRouter

    var body: some View {
        TabView(selection: $tabRouter.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(TabRouter.Tab.home)

            NavigationStack {
                AddItemView()
            }
            .tabItem {
                Label("Add", systemImage: "plus.circle.fill")
            }
            .tag(TabRouter.Tab.add)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }
            .tag(TabRouter.Tab.profile)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let userVM = UserViewModel(user: SampleData.user)
        let itemsVM = ItemsViewModel(items: SampleData.items(ownerId: SampleData.user.id))
        let cartVM = CartViewModel()
        let router = TabRouter()

        ContentView()
            .environmentObject(userVM)
            .environmentObject(itemsVM)
            .environmentObject(cartVM)
            .environmentObject(router)
    }
}
