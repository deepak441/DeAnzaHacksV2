import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var itemsVM: ItemsViewModel
    @EnvironmentObject private var cartVM: CartViewModel
    @EnvironmentObject private var tabRouter: TabRouter

    @State private var searchText = ""
    @State private var showingCart = false
    @State private var showingMenu = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Button {
                    showingMenu = true
                } label: {
                    Image(systemName: "line.3.horizontal")
                        .font(.title2)
                }
                Spacer()
                Text("Second Serve")
                    .font(.headline)
                Spacer()
                Spacer().frame(width: 24)
            }
            .padding(.horizontal)

            BannerView()
                .padding(.horizontal)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(filteredItems) { item in
                        NavigationLink {
                            ItemDetailView(item: item)
                        } label: {
                            ItemCardView(item: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)

                Spacer(minLength: 12)
            }

            searchAndCartRow
                .padding(.horizontal)
                .padding(.bottom, 8)
        }
        .sheet(isPresented: $showingCart) {
            NavigationStack {
                CartView()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") { showingCart = false }
                        }
                    }
            }
        }
        .sheet(isPresented: $showingMenu) {
            MenuView {
                showingMenu = false
            }
            .environmentObject(tabRouter)
        }
    }

    private var filteredItems: [Item] {
        guard !searchText.isEmpty else { return itemsVM.activeItems }
        return itemsVM.activeItems.filter { item in
            let term = searchText.lowercased()
            return item.name.lowercased().contains(term) ||
                item.category.lowercased().contains(term) ||
                (item.donation ? "donate" : "sell").contains(term)
        }
    }

    private var searchAndCartRow: some View {
        HStack(spacing: 12) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search food or type", text: $searchText)
                    .textInputAutocapitalization(.never)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

            Button {
                showingCart = true
            } label: {
                Image(systemName: "cart.fill")
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
            .frame(width: 70)
        }
    }
}

private struct BannerView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Save food, save money.")
                    .font(.headline)
                Text("Discover surplus meals nearby.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: "leaf.fill")
                .foregroundColor(.green)
                .font(.title2)
        }
        .padding()
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct ItemCardView: View {
    let item: Item

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 120)
                Image(systemName: "photo")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
            }

            Text(item.name)
                .font(.headline)

            HStack {
                Text(item.donation ? "Donate" : "Sell")
                    .font(.caption)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(item.donation ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                    .clipShape(Capsule())
                Spacer()
                Text(expiryText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text(priceText)
                    .font(.subheadline)
                    .bold()
                Spacer()
                if !item.sealed {
                    Text("Unsealed")
                        .font(.caption2)
                        .padding(6)
                        .background(Color.red.opacity(0.15))
                        .clipShape(Capsule())
                }
                if item.status == .pendingApproval {
                    Text("Pending")
                        .font(.caption2)
                        .padding(6)
                        .background(Color.orange.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private var priceText: String {
        if item.donation { return "Free" }
        let price = item.priceUSD ?? 0
        return "$\(String(format: "%.2f", price))"
    }

    private var expiryText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "Exp: \(formatter.string(from: item.expiryDate))"
    }
}
