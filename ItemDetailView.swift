import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    let item: Item
    @State private var showAdded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .frame(height: 220)
                    .overlay(
                        Image(systemName: "photo.on.rectangle")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    )

                HStack {
                    Text(item.name)
                        .font(.title2)
                        .bold()
                    Spacer()
                    Text(item.donation ? "Donate" : "Sell")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(item.donation ? Color.green.opacity(0.15) : Color.blue.opacity(0.15))
                        .clipShape(Capsule())
                }

                Text(item.description)
                    .font(.body)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Details")
                        .font(.headline)
                    DetailRow(title: "Expiry", value: dateText(item.expiryDate))
                    DetailRow(title: "Location", value: item.locationText)
                    if let price = item.priceUSD, !item.donation {
                        DetailRow(title: "Price", value: "$\(String(format: "%.2f", price))")
                    } else {
                        DetailRow(title: "Price", value: "Free")
                    }
                    DetailRow(title: "Sealed", value: item.sealed ? "Yes" : "No")
                    if !item.sealed {
                        DetailRow(title: "Warning", value: "Unsealed / open box")
                    }
                    DetailRow(title: "Status", value: item.status.displayName)
                }

                Button {
                    cartVM.addToCart(item)
                    showAdded = true
                } label: {
                    Text("Add to Cart")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.accentColor)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .padding()
        }
        .navigationTitle("Item Detail")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Added to cart", isPresented: $showAdded) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(item.name) added to cart.")
        }
    }

    private func dateText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

private struct DetailRow: View {
    let title: String
    let value: String
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
        }
        .font(.subheadline)
    }
}
