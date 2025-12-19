import SwiftUI

extension Color {
    static let backgroundCream = Color(#colorLiteral(red: 1, green: 0.976, blue: 0.9, alpha: 1))
    static let accentYellow = Color(#colorLiteral(red: 1, green: 0.850, blue: 0.239, alpha: 1))
    static let accentGreen = Color(#colorLiteral(red: 0.29, green: 0.81, blue: 0.8, alpha: 1))
    static let accentRed = Color(#colorLiteral(red: 1, green: 0.42, blue: 0.42, alpha: 1))
}


// MARK: - Root TabBar View
struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            DecodeView()
                .tabItem {
                    Label("Decode", systemImage: "magnifyingglass")
                }
            EncyclopediaView()
                .tabItem {
                    Label("Encyclopedia", systemImage: "book.fill")
                }
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .accentColor(.accentYellow)
        .background(Color.backgroundCream.edgesIgnoringSafeArea(.all))
    }
}

struct HomeView: View {
    @EnvironmentObject var historyVM: HistoryViewModel
    @State private var decodedData: EggInfo? = nil
    @State private var codeInput: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundCream.ignoresSafeArea()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Enter code from egg or package")
                        .font(.headline)
                        .padding(.top)
                        .padding(.horizontal)
                    
                    TextField("Code", text: $codeInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button(action: {
                        decodedData = EggInfo.sampleData(for: codeInput)
                    }) {
                        Text("Check code")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                    .padding(.top, 4)
                    .disabled(codeInput.isEmpty)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Where to find the code on egg or packaging:")
                            .font(.subheadline)
                            .bold()
                        Text("• On the shell or on the box label")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)

                    Divider().padding(.horizontal)

                    Text("Recent checks")
                        .font(.headline)
                        .padding(.horizontal)

                    if historyVM.historyItems.isEmpty {
                        Text("No recent checks yet.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        HistoryListView()
                    }

                    if let egg = decodedData {
                        EggInfoView(egg: egg)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HistoryListView: View {
    @EnvironmentObject var historyVM: HistoryViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(historyVM.historyItems.prefix(5)) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.code)
                                .font(.headline)
                            Text(item.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                        Text(item.result)
                            .foregroundColor(item.result == "Safe" ? .accentGreen : .accentRed)
                            .fontWeight(.semibold)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct DecodeView: View {
    @State private var codeInput = ""
    @State private var decodedData: EggInfo? = nil

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundCream.ignoresSafeArea()

                VStack(spacing: 16) {
                    TextField("Enter or scan code", text: $codeInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)

                    Button("Decode") {
                        decodedData = EggInfo.sampleData(for: codeInput)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.accentYellow)
                    .padding(.horizontal)

                    if let egg = decodedData {
                        EggInfoView(egg: egg)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(radius: 3)
                            .padding(.horizontal)
                    } else {
                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationTitle("Decode code")
        }
    }
}

struct EncyclopediaView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundCream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Egg Categories")
                            .font(.title2)
                            .bold()
                        Text("- C0: Premium Table Egg\n- C1: 1st Category\n- C2: 2nd Category\n- C3: 3rd Category")
                            .padding(.bottom)

                        Text("Types of Chicken Housing")
                            .font(.title2)
                            .bold()
                        Text("""
                            0 — Organic
                            1 — Floor
                            2 — Cage
                            3 — Industrial
                            """)
                            .padding(.bottom)

                        Text("Marking Standards by Country")
                            .font(.title2)
                            .bold()
                        Text("Explanation of different country codes and standards.")


                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Encyclopedia")
        }
    }
}


struct FavoritesView: View {
    @EnvironmentObject var favoritesVM: FavoritesViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundCream.ignoresSafeArea()

                if favoritesVM.favorites.isEmpty {
                    Text("No favorites yet.")
                        .foregroundColor(.gray)
                        .font(.headline)
                } else {
                    List {
                        ForEach(favoritesVM.favorites, id: \.self) { item in
                            Text(item)
                        }
                        .onDelete(perform: favoritesVM.remove)
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Favorites")
            .toolbar {
                EditButton()
            }
        }
    }
}

struct SettingsView: View {
    @EnvironmentObject var settingsVM: SettingsViewModel

    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundCream.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            Text("Notifications")
                                .font(.headline)
                            Toggle("Remind about egg expiry", isOn: $settingsVM.expiryReminder)
                                .toggleStyle(SwitchToggleStyle(tint: .accentYellow))
                        }

                        Divider()

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct EggInfo {
    let category: String
    let housing: String
    let country: String
    let factory: String
    let expiryDate: Date?
    let freshnessStatus: FreshnessStatus

    enum FreshnessStatus {
        case safe, expiringSoon, expired

        var color: Color {
            switch self {
            case .safe: return .accentGreen
            case .expiringSoon: return .accentYellow
            case .expired: return .accentRed
            }
        }
    }

    static func sampleData(for code: String) -> EggInfo {
        EggInfo(
            category: "C1",
            housing: "Floor (1)",
            country: "RU",
            factory: "Factory #12",
            expiryDate: Calendar.current.date(byAdding: .day, value: 5, to: Date()),
            freshnessStatus: .expiringSoon
        )
    }
}

struct EggInfoView: View {
    let egg: EggInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category: \(egg.category)")
            Text("Housing: \(egg.housing)")
            Text("Country: \(egg.country)")
            Text("Factory: \(egg.factory)")
            if let expiry = egg.expiryDate {
                Text("Expiry date: \(expiry, style: .date)")
                    .foregroundColor(egg.freshnessStatus.color)
            }
        }
        .font(.body)
    }
}

struct HistoryItem: Identifiable, Codable {
    var id: UUID = UUID()
    let code: String
    let date: Date
    let result: String
}

final class HistoryViewModel: ObservableObject {
    @Published var historyItems: [HistoryItem] = []

    private let key = "historyItems"

    init() {
        load()
    }

    func add(_ item: HistoryItem) {
        historyItems.insert(item, at: 0)
        save()
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let saved = try? JSONDecoder().decode([HistoryItem].self, from: data) else {
            return
        }
        historyItems = saved
    }

    func save() {
        if let encoded = try? JSONEncoder().encode(historyItems) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
}

final class FavoritesViewModel: ObservableObject {
    @Published var favorites: [String] = []
    private let key = "favorites"

    init() {
        load()
    }

    func add(_ code: String) {
        if !favorites.contains(code) {
            favorites.append(code)
            save()
        }
    }

    func remove(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        save()
    }

    func remove(_ item: String) {
        favorites.removeAll(where: { $0 == item })
        save()
    }

    func load() {
        favorites = UserDefaults.standard.stringArray(forKey: key) ?? []
    }

    func save() {
        UserDefaults.standard.set(favorites, forKey: key)
    }
}

final class SettingsViewModel: ObservableObject {
    @Published var language: String {
        didSet { save() }
    }
    @Published var expiryReminder: Bool {
        didSet { save() }
    }

    private let languageKey = "language"
    private let reminderKey = "expiryReminder"

    init() {
        language = UserDefaults.standard.string(forKey: languageKey) ?? "en"
        expiryReminder = UserDefaults.standard.bool(forKey: reminderKey)
    }

    func save() {
        UserDefaults.standard.set(language, forKey: languageKey)
        UserDefaults.standard.set(expiryReminder, forKey: reminderKey)
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryViewModel())
        .environmentObject(FavoritesViewModel())
        .environmentObject(SettingsViewModel())
}
