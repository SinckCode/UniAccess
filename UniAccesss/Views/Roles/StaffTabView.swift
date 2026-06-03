import SwiftUI

struct StaffTabView: View {
    var body: some View {
        TabView {
            NavigationStack { AdminDashboardView() }
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack { AdminMenuView() }
                .tabItem { Label("Gestion", systemImage: "square.grid.2x2.fill") }

            NavigationStack { RegistroUsuarioView() }
                .tabItem { Label("Cuentas", systemImage: "person.badge.plus") }

            NavigationStack { PlaceholderView(title: "Avisos", icon: "bell.fill") }
                .tabItem { Label("Avisos", systemImage: "bell.fill") }

            NavigationStack { SettingsView() }
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
        .tint(Color(hex: "#6B7280"))
    }
}
