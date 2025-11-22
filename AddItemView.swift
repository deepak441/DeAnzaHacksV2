import SwiftUI


struct AddItemView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var itemsVM: ItemsViewModel

    @State private var name: String = ""
    @State private var category: String = ""
    @State private var expiryDate: Date = Date()
    @State private var description: String = ""
    @State private var location: String = ""
    @State private var sealed: Bool = true
    @State private var donation: Bool = true
    @State private var price: String = ""
    @State private var statusMessage: String?
    @State private var showConfirmation = false
    @State private var showPhotoPicker = false
    @State private var showCameraPicker = false
    @State private var selectedImages: [UIImage] = []

    var body: some View {
        Form {
            Section("Listing Details") {
                TextField("Product Name", text: $name)
                TextField("Product Type / Category", text: $category)
                DatePicker("Expiration Date", selection: $expiryDate, displayedComponents: .date)
                TextEditor(text: $description)
                    .frame(minHeight: 80)
            }

            Section("Photos") {
                Button {
                    showPhotoPicker = true
                } label: {
                    Label("Choose from library", systemImage: "photo.on.rectangle")
                }
                Button {
                    showCameraPicker = true
                } label: {
                    Label("Take photo", systemImage: "camera")
                }
                if !selectedImages.isEmpty {
                    Text("\(selectedImages.count) photo(s) attached")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            Section("Location & Safety") {
                TextField("City / Zip / Address", text: $location)
                Toggle("Item is sealed/closed", isOn: $sealed)
                if !sealed {
                    Label("Unsealed items cannot be donated.", systemImage: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .font(.footnote)
                }
            }

            Section("Donate or Sell") {
                Picker("Type", selection: $donation) {
                    Text("Donate").tag(true).disabled(!sealed)
                    Text("Sell").tag(false)
                }
                .pickerStyle(.segmented)
                .onChange(of: sealed) { newValue in
                    if !newValue {
                        donation = false
                    }
                }
				.onChange(of: donation) { newValue in
					if newValue && !sealed {
						donation = false
					}
				}
				
                if !donation {
                    TextField("Price (USD)", text: $price)
                        .keyboardType(.decimalPad)
                }
                if !sealed {
                    Text("Sealed is required for donations. This listing will be treated as Sell.")
                        .font(.footnote)
                        .foregroundColor(.orange)
                }
            }

            Section {
                Button(action: submit) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                }
                .disabled(name.isEmpty || category.isEmpty || description.isEmpty || location.isEmpty || (!donation && price.isEmpty))
            }
        }
        .navigationTitle("Add Item")
        .sheet(isPresented: $showPhotoPicker) {
            ImagePicker(sourceType: .photoLibrary) { image in
                if let image { selectedImages.append(image) }
            }
        }
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera) { image in
                if let image { selectedImages.append(image) }
            }
        }
        .alert(isPresented: $showConfirmation) {
            Alert(title: Text("Submitted"),
                  message: Text(statusMessage ?? ""),
                  dismissButton: .default(Text("OK"), action: resetForm))
        }
    }

    private func submit() {
        let newItem = Item(
            id: UUID(),
            ownerId: userVM.currentUser.id,
            name: name,
            category: category,
            donation: donation,
            sealed: sealed,
            expiryDate: expiryDate,
            description: description,
            photoURLs: nil,
            priceUSD: donation ? nil : Double(price),
            locationText: location,
            status: donation ? .active : .pendingApproval,
            createdAt: Date()
        )

        itemsVM.addItem(newItem)
        if donation {
            userVM.addPoints(10)
            statusMessage = "Thank you for donating, we will get back to you soon!"
        } else {
            userVM.addPoints(2)
            statusMessage = "Your product was submitted and is pending approval."
        }
        showConfirmation = true
    }

    private func resetForm() {
        name = ""
        category = ""
        description = ""
        location = ""
        sealed = true
        donation = true
        price = ""
        expiryDate = Date()
    }
}
