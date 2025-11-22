import SwiftUI

enum ProfileTab: String, CaseIterable, Identifiable {
    case seller = "Seller"
    case profile = "Profile Settings"
    case preferences = "Preference"
    case privacy = "Privacy"

    var id: String { rawValue }
}

struct ProfileView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @EnvironmentObject private var itemsVM: ItemsViewModel

    @State private var selectedTab: ProfileTab = .seller

    var body: some View {
        VStack(spacing: 12) {
            header

            Picker("Profile Tabs", selection: $selectedTab) {
                ForEach(ProfileTab.allCases) { tab in
                    Text(tab.rawValue).tag(tab)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)

            TabView(selection: $selectedTab) {
                SellerView(items: itemsVM.itemsForUser(userVM.currentUser.id))
                    .tag(ProfileTab.seller)
                ProfileSettingsView()
                    .tag(ProfileTab.profile)
                PreferencesView()
                    .tag(ProfileTab.preferences)
                PrivacySettingsView()
                    .tag(ProfileTab.privacy)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .navigationTitle("Profile")
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(userVM.currentUser.name)
                    .font(.title2)
                    .bold()
                Text("Points: \(userVM.currentUser.points)")
                    .font(.headline)
                    .foregroundColor(.green)
            }
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .font(.largeTitle)
                .foregroundColor(.accentColor)
        }
        .padding(.horizontal)
    }
}

private struct SellerView: View {
    let items: [Item]
    @State private var selectedItem: Item?

    var body: some View {
        List {
            ForEach(items) { item in
                Button {
                    selectedItem = item
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.donation ? "Donate" : "Sell")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text(item.status.displayName)
                                .font(.caption)
                                .padding(6)
                                .background(Color(.tertiarySystemFill))
                                .clipShape(Capsule())
                            Text(expiryText(for: item.expiryDate))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedItem) { item in
            NavigationStack {
                ItemDetailView(item: item)
            }
        }
    }

    private func expiryText(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return "Exp: \(formatter.string(from: date))"
    }
}

private struct ProfileSettingsView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phone: String = ""
    @State private var radius: Double = 10

    var body: some View {
        Form {
            Section("Profile") {
                TextField("Display Name", text: $name)
                TextField("Contact Email", text: $email)
                TextField("Phone", text: $phone)
                Stepper(value: $radius, in: 1...100, step: 1) {
                    Text("Search Radius: \(Int(radius)) miles")
                }
            }

            Button("Save") {
                userVM.updateProfile(
                    name: name.isEmpty ? userVM.currentUser.name : name,
                    email: email.isEmpty ? userVM.currentUser.email : email,
                    phone: phone.isEmpty ? userVM.currentUser.phone : phone,
                    radiusMiles: radius
                )
            }
        }
        .onAppear {
            name = userVM.currentUser.name
            email = userVM.currentUser.email ?? ""
            phone = userVM.currentUser.phone ?? ""
            radius = userVM.currentUser.radiusMiles ?? 10
        }
    }
}

private struct PreferencesView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @State private var selections: Set<String> = []

    private let options = ["Vegan", "Vegetarian", "Halal", "Kosher", "Gluten-free", "Nut-free"]

    var body: some View {
        List {
            ForEach(options, id: \.self) { option in
                Toggle(option, isOn: Binding<Bool>(
                    get: { selections.contains(option) },
                    set: { isOn in
                        if isOn {
                            selections.insert(option)
                        } else {
                            selections.remove(option)
                        }
                        userVM.updatePreferences(Array(selections))
                    }
                ))
            }
        }
        .onAppear {
            selections = Set(userVM.currentUser.dietaryPreferences)
        }
    }
}

private struct PrivacySettingsView: View {
    @EnvironmentObject private var userVM: UserViewModel
    @State private var maskAddress: Bool = true
    @State private var inAppMessagingOnly: Bool = true
    @State private var aiDataOptIn: Bool = false
    @State private var aiConsent: Bool = false

    var body: some View {
        Form {
            Section("Privacy") {
                Toggle("Mask address until order is confirmed", isOn: $maskAddress)
                Toggle("Allow in-app messaging only", isOn: $inAppMessagingOnly)
                Toggle("Opt in to anonymized AI image data program", isOn: $aiDataOptIn)
            }

            if aiDataOptIn {
                Text("Your images may be used in anonymized AI datasets and you can earn bonus points.")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }

            Section("Consent") {
                Toggle("AI Data Program Consent", isOn: $aiConsent)
            }

            Button("Save") {
                let privacy = PrivacySettings(
                    maskAddress: maskAddress,
                    inAppMessagingOnly: inAppMessagingOnly,
                    aiDataOptIn: aiDataOptIn
                )
                let consents = Consents(
                    aiDataProgram: aiConsent,
                    createdAt: Date()
                )
                userVM.updatePrivacy(privacy, consents: consents)
            }
        }
        .onAppear {
            let privacy = userVM.currentUser.privacySettings
            maskAddress = privacy.maskAddress
            inAppMessagingOnly = privacy.inAppMessagingOnly
            aiDataOptIn = privacy.aiDataOptIn
            aiConsent = userVM.currentUser.consents.aiDataProgram
        }
    }
}
