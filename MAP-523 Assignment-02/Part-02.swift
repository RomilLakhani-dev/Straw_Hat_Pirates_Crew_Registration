//
//  Part-02.swift
//  MAP-523 Assignment-02
//
//  Created by Romil on 2025-10-01.
//


import SwiftUI

struct Part2View: View {
    
    @State private var username: String = "Romil Lakhani"
    @State private var handle: String = "@Rklakhani"

    @State private var isDarkMode: Bool = true
    @State private var language: String = "English"

    @State private var closeFriendsCount: Int = 203
    @State private var favoritesCount: Int = 45
    @State private var blockedCount: Int = 5

    @State private var showEditProfileSheet: Bool = false
    @State private var showToast: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    profileHeaderCard

                    PillSectionHeader(title: "Content")
                    SettingsGroup {
                        SettingsNavRow(systemImage: "lock.fill", title: "Account privacy", trailing: "Private") {
                            PlaceholderDetail(title: "Account privacy")
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "person.2.fill", title: "Close friends", trailing: "\(closeFriendsCount)") {
                            CounterDetail(title: "Close friends", count: $closeFriendsCount)
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "star.fill", title: "Favorites", trailing: "\(favoritesCount)") {
                            CounterDetail(title: "Favorites", count: $favoritesCount)
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "nosign", title: "Blocked", trailing: "\(blockedCount)") {
                            CounterDetail(title: "Blocked", count: $blockedCount)
                        }
                    }

                    PillSectionHeader(title: "Preferences")
                    SettingsGroup {
                        SettingsNavRow(systemImage: "figure.walk", title: "Accessibility") {
                            PlaceholderDetail(title: "Accessibility")
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "bell.fill", title: "Notifications") {
                            PlaceholderDetail(title: "Notifications")
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "globe", title: "Language", trailing: language) {
                            LanguageDetail(selectedLanguage: $language)
                        }
                        Divider().opacity(0.08)
                        SettingsToggleRow(systemImage: "moon.fill", title: "Dark Mode", isOn: $isDarkMode)
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "chart.bar.fill", title: "Data usage") {
                            PlaceholderDetail(title: "Data usage")
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "arrow.down.circle.fill", title: "Downloads") {
                            PlaceholderDetail(title: "Downloads")
                        }
                    }

                    PillSectionHeader(title: "Support")
                    SettingsGroup {
                        SettingsNavRow(systemImage: "questionmark.circle.fill", title: "Help") {
                            PlaceholderDetail(title: "Help")
                        }
                        Divider().opacity(0.08)
                        SettingsNavRow(systemImage: "info.circle.fill", title: "About") {
                            PlaceholderDetail(title: "About")
                        }
                    }

                    PillSectionHeader(title: "Login")
                    SettingsGroup {
                        SettingsButtonRow(systemImage: "person.badge.plus", title: "Add account", titleColor: .blue) {
                            showToastMessage("Account added")
                        }
                        Divider().opacity(0.08)
                        SettingsButtonRow(systemImage: "rectangle.portrait.and.arrow.right", title: "Log out \(handle)", titleColor: .red) {
                            showToastMessage("Logged out")
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Settings")
            .toolbarTitleDisplayMode(.inline)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .tint(.purple)
            .toast(isPresented: $showToast) {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    Text("Done").font(.subheadline.weight(.semibold))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
            }
        }
    }
}

// Sections & Components
private extension Part2View {
    var profileHeaderCard: some View {
        VStack(spacing: 12) {
            Circle()
                .fill(LinearGradient(colors: [.purple.opacity(0.25), .blue.opacity(0.25)], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 76, height: 76)
                .overlay(
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 54))
                        .foregroundStyle(.white.opacity(0.9))
                )

            Text(username)
                .font(.headline)
            Text(handle)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Button {
                showEditProfileSheet = true
            } label: {
                Text("Edit Profile")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 16)
                    .background(Capsule().fill(Color.purple))
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
        .sheet(isPresented: $showEditProfileSheet) {
            EditProfileSheet(username: $username, handle: $handle) {
                showEditProfileSheet = false
                showToastMessage("Profile updated")
            }
            .presentationDetents([.medium])
        }
    }

    func showToastMessage(_ text: String) {
        // Reuse the toast container; swap label text by briefly toggling.
        showToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            showToast = false
        }
    }
}

// Reusable Building Blocks
private struct PillSectionHeader: View {
    let title: String
    var body: some View {
        Text(title.uppercased())
            .font(.caption).bold()
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.06))
            )
            .padding(.top, 8)
    }
}

private struct SettingsGroup<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.06))
        )
    }
}

private struct RowLabel: View {
    let systemImage: String
    let title: String
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .frame(width: 24, height: 24)
            Text(title)
        }
    }
}

private struct SettingsNavRow<Destination: View>: View {
    let systemImage: String
    let title: String
    var trailing: String? = nil
    @ViewBuilder var destination: Destination

    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 12) {
                RowLabel(systemImage: systemImage, title: title)
                Spacer()
                if let trailing {
                    Text(trailing).foregroundStyle(.secondary)
                }
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsButtonRow: View {
    let systemImage: String
    let title: String
    var titleColor: Color = .primary
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                RowLabel(systemImage: systemImage, title: title)
                    .foregroundStyle(titleColor)
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

private struct SettingsToggleRow: View {
    let systemImage: String
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            RowLabel(systemImage: systemImage, title: title)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.vertical, 14)
    }
}

private struct PlaceholderDetail: View {
    let title: String
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "gearshape.fill").font(.largeTitle)
            Text(title)
                .font(.title2.bold())
            Text("This is a placeholder screen.")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemBackground))
    }
}

private struct CounterDetail: View {
    let title: String
    @Binding var count: Int
    var body: some View {
        VStack(spacing: 16) {
            Text(title).font(.title3.bold())
            Stepper("Count: \(count)", value: $count, in: 0...99)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(Color(.systemBackground))
    }
}

private struct LanguageDetail: View {
    @Binding var selectedLanguage: String
    let options = ["English", "Spanish", "French", "German", "Japanese"]
    var body: some View {
        List(options, id: \.self) { lang in
            HStack {
                Text(lang)
                Spacer()
                if lang == selectedLanguage {
                    Image(systemName: "checkmark").foregroundStyle(.purple)
                }
            }
            .contentShape(Rectangle())
            .onTapGesture { selectedLanguage = lang }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Language")
    }
}

private struct EditProfileSheet: View {
    @Binding var username: String
    @Binding var handle: String
    var onSave: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    TextField("Name", text: $username)
                    TextField("Handle", text: $handle)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Edit Profile")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                        onSave()
                    }
                }
            }
        }
    }
}

//Toast helper
private extension View {
    // Simple toast overlay used for confirmations.
    func toast<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        ZStack(alignment: .bottom) {
            self
            if isPresented.wrappedValue {
                content()
                    .padding(.bottom, 24)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .animation(.easeInOut, value: isPresented.wrappedValue)
            }
        }
    }
}

#Preview {
    Part2View()
}

