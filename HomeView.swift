import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var itemsVM: ItemsViewModel
    @EnvironmentObject private var cartVM: CartViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    // MARK: - Points Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Your Points")
                                .font(.headline)
                            Spacer()
                            Text("\(userVM.currentUser.points) pts")
                                .font(.subheadline)
                                .bold()
                        }
                        .padding(.horizontal)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                // Example deals
                                RedeemDealView(title: "Free Coffee", cost: 10)
                                RedeemDealView(title: "Discounted Bagel", cost: 15)
                                RedeemDealView(title: "Gift Card $5", cost: 50)
                            }
                            .padding(.horizontal)
                        }

                        Divider()
                    }
                    .padding(.vertical, 8)

                    // MARK: - Items Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Available Items")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        ForEach(itemsVM.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)
                                            .environmentObject(cartVM)) {
                                ItemRowView(item: item)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
}

// MARK: - Redeem Deal Card
struct RedeemDealView: View {
    let title: String
    let cost: Int

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.subheadline)
                .bold()
                .multilineTextAlignment(.center)
                .frame(width: 120)
            Text("\(cost) pts")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.accentColor.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Item Row View
struct ItemRowView: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.secondarySystemBackground))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "photo.on.rectangle")
                        .font(.title2)
                        .foregroundColor(.secondary)
                )

            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.category)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(item.donation ? "Donate" : "$\(String(format: "%.2f", item.priceUSD ?? 0))")
                .font(.subheadline)
                .padding(6)
                .background(item.donation ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                .clipShape(Capsule())
        }
        .padding(.vertical, 4)
    }
}
