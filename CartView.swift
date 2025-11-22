import SwiftUI

struct CartView: View {
    @EnvironmentObject private var cartVM: CartViewModel
    @State private var showConfirmation = false

    var body: some View {
        List {
            Section("Items") {
                if cartVM.items.isEmpty {
                    Text("Your cart is empty.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(cartVM.items) { cartItem in
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(cartItem.item.name)
                                    .font(.headline)
                                Text(cartItem.item.donation ? "Donate" : "Sell")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Text("x\(cartItem.quantity)")
                            if let price = cartItem.item.priceUSD, !cartItem.item.donation {
                                Text("$\(String(format: "%.2f", price * Double(cartItem.quantity)))")
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                            } else {
                                Text("Free")
                                    .font(.subheadline)
                                    .padding(.leading, 8)
                            }
                        }
                    }
                }
            }

            if !cartVM.items.isEmpty {
                Section {
                    HStack {
                        Text("Total")
                        Spacer()
                        Text("$\(String(format: "%.2f", cartVM.totalPrice))")
                            .bold()
                    }
                }
            }
        }
        .navigationTitle("Cart")
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button {
                    showConfirmation = true
                } label: {
                    Text("Checkout")
                        .frame(maxWidth: .infinity)
                }
                .disabled(cartVM.items.isEmpty)
            }
        }
        .alert("Order placed", isPresented: $showConfirmation) {
            Button("OK") {
                cartVM.clearCart()
            }
        } message: {
            Text("Order placed. Pickup details will be shared soon.")
        }
    }
}
