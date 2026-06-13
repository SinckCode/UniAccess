import SwiftUI

struct AlumnoTabView: View {
    var body: some View {
        TabView {
            NavigationStack { AlumnoDashboardView() }
                .tabItem { Label("Inicio", systemImage: "house.fill") }

            NavigationStack { MisMateriasAlumnoView() }
                .tabItem { Label("Materias", systemImage: "book.fill") }

            NavigationStack { HorarioAlumnoView() }
                .tabItem { Label("Horario", systemImage: "calendar") }

            NavigationStack { CalificacionesAlumnoView() }
                .tabItem { Label("Calificaciones", systemImage: "checkmark.seal.fill") }

            NavigationStack { AlumnoPerfilView() }
                .tabItem { Label("Perfil", systemImage: "person.fill") }
        }
        .tint(Color(hex: "#2E7D32"))
    }
}
