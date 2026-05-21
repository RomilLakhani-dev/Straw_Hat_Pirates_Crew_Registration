//
//  Part-01.swift
//
//  Created by Romil on 2025-10-01.
//



import SwiftUI

struct Part1View: View {
    @State private var pirateName = ""
    @State private var contactShell = ""
    @State private var bountyID = ""
    @State private var secretPower = ""
    @State private var confirmPower = ""
    @State private var joinStrawHatsForever = false
    @State private var treasureUpdates = true
    @State private var startingBounty: Double = 50
    @State private var showWelcome = false

    let bountyRange: ClosedRange<Double> = 50...500
    let bountyStep: Double = 10
    let bountyIDLimit = 20

    var powersMatch: Bool? {
        guard !confirmPower.isEmpty else { return nil }
        return confirmPower == secretPower
    }
    
    var powerLevel: String {
        let count = secretPower.count
        switch count {
        case 0:
            return ""
        case 1...5:
            return "East Blue Level"
        case 6...8:
            return "Grand Line Level"
        default:
            return "New World Level"
        }
    }

    var formattedBounty: String { "\(Int(startingBounty))0M฿" }

    var body: some View {
            ScrollView {
                VStack(spacing: 32) {
                    
                    // Header
                    VStack(spacing: 8) {
                        Text("⛵️").font(.system(size: 48))
                        Text("Straw Hat Pirates").font(.largeTitle.bold())
                        Text("Join the crew").foregroundStyle(.secondary)
                        Text("\"I'm gonna be King of the Pirates!\"")
                            .font(.subheadline).foregroundStyle(.red).italic()
                    }
                    .padding(.bottom, 8)
                    
                    // Personal Info
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Personal Info").font(.title.bold())
                        
                        entryFieldRow("👑 Pirate Name", valid: !pirateName.isEmpty) {
                            TextField("What's your dream name?", text: $pirateName)
                                .padding(14)
                        }
                        
                        entryFieldRow("📞 Den Den Mushi",
                                 state: !contactShell.isEmpty ? isValidEmail(contactShell) : nil) {
                            VStack(alignment: .leading, spacing: 4) {
                                TextField("", text: $contactShell, prompt: Text(verbatim: "contact@grandline.sea").foregroundStyle(.primary))
                                
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding(14)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(!contactShell.isEmpty && !isValidEmail(contactShell) ? .red : .clear, lineWidth: 2)
                                            .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 12))
                                    )
                            }
                            if !contactShell.isEmpty && !isValidEmail(contactShell) {
                                Text("Invalid Email Format")
                                    .font(.caption)
                                    .foregroundStyle(.red)
                            }
                        }
                        
                        
                        entryFieldRow("⭐️ Bounty ID", valid: !bountyID.isEmpty) {
                            TextField("Your wanted poster name", text: $bountyID)
                                .onChange(of: bountyID) { oldValue, newValue in
                                    bountyID = String(newValue.prefix(bountyIDLimit))
                                }
                            
                                .padding(14)
                        }
                        
                        Text("\(bountyID.count)/\(bountyIDLimit) characters")
                            .font(.caption).foregroundStyle(.secondary)
                            .padding(.leading, 4)
                    }
                    
                    // Devil Fruit Powers
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 4){
                            Text("Devil Fruit Powers").font(.title.bold())
                            
                            entryFieldRow("🔥 Secret Power", valid: !secretPower.isEmpty) {
                                SecureField("Your hidden ability", text: $secretPower)
                                    .textInputAutocapitalization(.never)
                                    .disableAutocorrection(true)
                                    .padding(14)
                            }
                            
                            if !secretPower.isEmpty {
                                Text(powerLevel)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }}
                        
                        entryFieldRow("✅ Confirm Power", state: powersMatch) {
                            SecureField("Re-enter your power", text: $confirmPower)
                                .padding(14)
                                .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(powersMatch == false ? .red : .clear, lineWidth: 2))
                        }
                        
                        if powersMatch == false {
                            Text("Powers don't match").font(.caption).foregroundStyle(.red)
                        }
                    }
                    
                    // Crew Preferences
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Crew Preferences").font(.title.bold())
                        
                        Toggle(isOn: $joinStrawHatsForever) {
                            HStack {
                                Text("💖").font(.headline)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Join Straw Hats Forever").font(.headline)
                                    Text("Loyalty to Luffy & crew")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .tint(.yellow)
                        
                        Toggle(isOn: $treasureUpdates) {
                            HStack {
                                Text("🗺️").font(.headline)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Treasure Updates").font(.headline)
                                    Text("Adventure notifications")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .tint(.yellow)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .firstTextBaseline) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Starting Bounty").font(.headline)
                                    Text("Set your initial reward")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(formattedBounty)
                                    .font(.headline.monospaced())
                                    .foregroundStyle(.yellow)
                            }
                            
                            Slider(value: $startingBounty, in: bountyRange, step: bountyStep)
                                .tint(.yellow)
                            
                            HStack {
                                Text("\(Int(bountyRange.lowerBound))฿")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("\(Int(bountyRange.upperBound))0M฿")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.top, 8)
                    }
                    
                    
                    // Button
                    Button("⛵️ Set Sail 🏴‍☠️") {
                        hideKeyboard()
                        showWelcome = true
                    }
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(RoundedRectangle(cornerRadius: 24).fill(.red))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .alert("Welcome to the Crew! 🎉", isPresented: $showWelcome) {
                Button("Start Adventure") {
                    resetForm()
                }
                Button("Stay Here", role: .cancel) {}
            } message: {
                Text("You're now a Straw Hat Pirate with a \(formattedBounty) bounty!")
            }
        
    }

    // Small helpers
    func entryFieldRow<Content: View>(
        _ title: String,
        valid: Bool? = nil,
        state: Bool? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title).font(.headline)
                Spacer()
                if let s = state {
                    Image(systemName: s ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                        .foregroundStyle(s ? .green : .red)
                } else if valid == true {
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                }
            }
            content()
                .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
        }
    }

    func isValidEmail(_ s: String) -> Bool {
        s.contains("@") && s.contains(".") && s.count > 5
    }

    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
    func resetForm() {
        pirateName = ""
        contactShell = ""
        bountyID = ""
        secretPower = ""
        confirmPower = ""
        joinStrawHatsForever = false
        treasureUpdates = true
        startingBounty = 50
    }

}

#Preview {
    Part1View()
}

