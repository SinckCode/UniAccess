import SwiftUI

struct ProfesorPerfilView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = ProfesorViewModel()
    @State private var showLogout = false

    private var profesor: Profesor? { vm.profesores.first { $0.idProfesor == session.entityId } }

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color(hex: "#2E7D32").opacity(0.12)).frame(width: 56, height: 56)
                        Image(systemName: "person.text.rectangle").font(.title2).foregroundColor(Color(hex: "#2E7D32"))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.nombre).font(.headline)
                        Text("Profesor").font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }
                }
                .padding(.vertical, 6)
            }

            Section("Datos Profesionales") {
                if let esp = profesor?.especialidad { LabeledContent("Especialidad", value: esp) }
                if let est = profesor?.estatus { LabeledContent("Estatus", value: est.capitalized) }
            }

            Section("Contacto") {
                LabeledContent("Correo", value: profesor?.correo ?? "—")
                if let tel = profesor?.telefono { LabeledContent("Telefono", value: tel) }
            }

            Section {
                Button(role: .destructive) { showLogout = true } label: {
                    HStack { Image(systemName: "rectangle.portrait.and.arrow.right"); Text("Cerrar Sesion") }
                }
            }
        }
        .navigationTitle("Mi Perfil")
        .task { await vm.fetchAll() }
        .alert("Cerrar Sesion", isPresented: $showLogout) {
            Button("Cerrar Sesion", role: .destructive) { session.logout() }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Tu sesion sera cerrada.") }
    }
}
