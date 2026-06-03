import SwiftUI

struct AlumnoDetailView: View {
    let alumno: Alumno
    @ObservedObject var vm: AlumnoViewModel
    @StateObject private var carreraVM = CarreraViewModel()
    @State private var showEditForm = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    private var nombreCarrera: String {
        carreraVM.carreras.first { $0.idCarrera == alumno.idCarrera }?.nombre ?? "ID: \(alumno.idCarrera)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                personalCard
                academicCard
                contactCard
                deleteButton
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Detalle Alumno")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .primaryAction) { Button("Editar") { showEditForm = true } } }
        .sheet(isPresented: $showEditForm) { AlumnoFormView(vm: vm, alumno: alumno) }
        .task { await carreraVM.fetchAll() }
        .alert("Eliminar Alumno", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = alumno.idAlumno { Task { await vm.delete(id: id); dismiss() } }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color(hex: "#00897B").opacity(0.12)).frame(width: 64, height: 64)
                    Image(systemName: "person.3.fill").font(.title).foregroundColor(Color(hex: "#00897B"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(alumno.nombreCompleto).font(.title3).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(alumno.matricula).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    if let est = alumno.estatus { StatusBadge(text: est) }
                }
                Spacer()
            }
        }
    }

    private var personalCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Datos Personales").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("ID", "\(alumno.idAlumno ?? 0)")
                row("Nombre", alumno.nombre)
                row("Ap. Paterno", alumno.apellidoPaterno)
                if let am = alumno.apellidoMaterno { row("Ap. Materno", am) }
                row("Fecha Ingreso", alumno.fechaIngreso)
            }
        }
    }

    private var academicCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Datos Academicos").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("Semestre", "\(alumno.semestre)")
                row("Carrera", nombreCarrera)
            }
        }
    }

    private var contactCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Contacto").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("Correo", alumno.correo)
                if let tel = alumno.telefono { row("Telefono", tel) }
            }
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(Color(hex: "#6B7280")).frame(width: 110, alignment: .leading)
            Text(value).font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "#1A1A1A"))
            Spacer()
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) { showDeleteAlert = true } label: {
            HStack { Image(systemName: "trash"); Text("Eliminar Alumno") }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color(hex: "#D32F2F").opacity(0.1))
                .foregroundColor(Color(hex: "#D32F2F")).cornerRadius(12)
        }
    }
}
