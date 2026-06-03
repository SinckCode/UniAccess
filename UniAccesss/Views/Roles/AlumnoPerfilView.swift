import SwiftUI

struct AlumnoPerfilView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = AlumnoViewModel()
    @StateObject private var carreraVM = CarreraViewModel()
    @State private var showLogout = false

    private var alumno: Alumno? { vm.alumnos.first { $0.idAlumno == session.entityId } }
    private var carrera: Carrera? { carreraVM.carreras.first { $0.idCarrera == alumno?.idCarrera } }

    var body: some View {
        List {
            Section {
                HStack(spacing: 14) {
                    ZStack {
                        Circle().fill(Color(hex: "#00897B").opacity(0.12)).frame(width: 56, height: 56)
                        Image(systemName: "person.fill").font(.title2).foregroundColor(Color(hex: "#00897B"))
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(session.nombre).font(.headline)
                        Text("Alumno").font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }
                }
                .padding(.vertical, 6)
            }

            Section("Datos Academicos") {
                LabeledContent("Matricula", value: alumno?.matricula ?? "—")
                LabeledContent("Semestre", value: "\(alumno?.semestre ?? 0)")
                LabeledContent("Carrera", value: carrera?.nombre ?? "—")
                LabeledContent("Facultad", value: carrera?.facultad ?? "—")
                if let est = alumno?.estatus {
                    LabeledContent("Estatus", value: est.capitalized)
                }
            }

            Section("Contacto") {
                LabeledContent("Correo", value: alumno?.correo ?? "—")
                if let tel = alumno?.telefono { LabeledContent("Telefono", value: tel) }
            }

            Section {
                Button(role: .destructive) { showLogout = true } label: {
                    HStack { Image(systemName: "rectangle.portrait.and.arrow.right"); Text("Cerrar Sesion") }
                }
            }
        }
        .navigationTitle("Mi Perfil")
        .task { await vm.fetchAll(); await carreraVM.fetchAll() }
        .alert("Cerrar Sesion", isPresented: $showLogout) {
            Button("Cerrar Sesion", role: .destructive) { session.logout() }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Tu sesion sera cerrada.") }
    }
}
