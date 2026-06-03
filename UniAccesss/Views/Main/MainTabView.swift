import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Inicio", systemImage: "house.fill")
            }

            NavigationStack {
                PlaceholderView(title: "Horario", icon: "calendar")
            }
            .tabItem {
                Label("Horario", systemImage: "calendar")
            }

            NavigationStack {
                PlaceholderView(title: "Notas", icon: "doc.text.fill")
            }
            .tabItem {
                Label("Notas", systemImage: "doc.text.fill")
            }

            NavigationStack {
                PlaceholderView(title: "Avisos", icon: "bell.fill")
            }
            .tabItem {
                Label("Avisos", systemImage: "bell.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Perfil", systemImage: "person.fill")
            }
        }
        .tint(Color(hex: "#2E7D32"))
    }
}

struct PlaceholderView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 56))
                .foregroundColor(Color(hex: "#6B7280").opacity(0.4))
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Color(hex: "#6B7280"))
            Text("Proximamente")
                .font(.subheadline)
                .foregroundColor(Color(hex: "#6B7280").opacity(0.6))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle(title)
    }
}
