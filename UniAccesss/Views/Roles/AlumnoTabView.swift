import SwiftUI

struct AlumnoTabView: View {
    var body: some View {
        TabView {
            NavigationStack { AlumnoDashboardView() }
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack { MisMateriasAlumnoView() }
                .tabItem { Label("Materias", systemImage: "book.fill") }

            NavigationStack { PlaceholderView(title: "Horario", icon: "calendar") }
                .tabItem { Label("Horario", systemImage: "calendar") }

            NavigationStack { PlaceholderView(title: "Avisos", icon: "bell.fill") }
                .tabItem { Label("Avisos", systemImage: "bell.fill") }

            NavigationStack { AlumnoPerfilView() }
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
        .tint(Color(hex: "#2E7D32"))
    }
}
