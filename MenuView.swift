import SwiftUI

struct MenuView: View {
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var cartVM: CartViewModel

    let close: () -> Void

    var body: some View {
        NavigationStack {
            List {
                Section("Navigate") {
                    menuButton(title: "Home", systemImage: "house.fill", tab: .home)
                    menuButton(title: "Add Item", systemImage: "plus.circle", tab: .add)
                    menuButton(title: "Profile", systemImage: "person.fill", tab: .profile)
                }

                Section("Quick Links") {
                    NavigationLink {
                        CartView()
                    } label: {
                        HStack {
                            Label("Cart", systemImage: "cart.fill")
                            Spacer()
                            if !cartVM.items.isEmpty {
                                Text("\(cartVM.items.count)")
                                    .font(.caption2)
                                    .padding(6)
                                    .background(Color.accentColor.opacity(0.2))
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .navigationTitle("Menu")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", action: close)
                }
            }
        }
    }

    private func menuButton(title: String, systemImage: String, tab: TabRouter.Tab) -> some View {
        Button {
            tabRouter.selectedTab = tab
            close()
        } label: {
            Label(title, systemImage: systemImage)
                .foregroundColor(.primary)
        }
    }
}
