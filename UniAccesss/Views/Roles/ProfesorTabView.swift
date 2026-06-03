import SwiftUI

struct ProfesorTabView: View {
    var body: some View {
        TabView {
            NavigationStack { ProfesorDashboardView() }
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack { MisMateriasProfesorView() }
                .tabItem { Label("Materias", systemImage: "book.fill") }

            NavigationStack { AlumnoListView() }
                .tabItem { Label("Alumnos", systemImage: "person.3.fill") }

            NavigationStack { PlaceholderView(title: "Avisos", icon: "bell.fill") }
                .tabItem { Label("Avisos", systemImage: "bell.fill") }

            NavigationStack { ProfesorPerfilView() }
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
        .tint(Color(hex: "#2E7D32"))
    }
}
