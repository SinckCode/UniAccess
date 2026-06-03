import SwiftUI

struct MateriaDetailView: View {
    let materia: Materia
    @ObservedObject var vm: MateriaViewModel
    @StateObject private var carreraVM = CarreraViewModel()
    @StateObject private var profesorVM = ProfesorViewModel()
    @State private var showEditForm = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    private var nombreCarrera: String {
        carreraVM.carreras.first { $0.idCarrera == materia.idCarrera }?.nombre ?? "ID: \(materia.idCarrera)"
    }
    private var nombreProfesor: String {
        profesorVM.profesores.first { $0.idProfesor == materia.idProfesor }?.nombreCompleto ?? "ID: \(materia.idProfesor)"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                infoCard
                deleteButton
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Detalle Materia")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .primaryAction) { Button("Editar") { showEditForm = true } } }
        .sheet(isPresented: $showEditForm) { MateriaFormView(vm: vm, materia: materia) }
        .task { await carreraVM.fetchAll(); await profesorVM.fetchAll() }
        .alert("Eliminar Materia", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = materia.idMateria { Task { await vm.delete(id: id); dismiss() } }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color(hex: "#F9A825").opacity(0.15)).frame(width: 64, height: 64)
                    Image(systemName: "book.fill").font(.title).foregroundColor(Color(hex: "#F9A825"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(materia.nombre).font(.title3).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(materia.clave).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                }
                Spacer()
            }
        }
    }

    private var infoCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Informacion").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("ID", "\(materia.idMateria ?? 0)")
                row("Creditos", "\(materia.creditos)")
                row("Semestre", "\(materia.semestre)")
                row("Carrera", nombreCarrera)
                row("Profesor", nombreProfesor)
            }
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(Color(hex: "#6B7280")).frame(width: 90, alignment: .leading)
            Text(value).font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "#1A1A1A"))
            Spacer()
        }
    }

    private var deleteButton: some View {
        Button(role: .destructive) { showDeleteAlert = true } label: {
            HStack { Image(systemName: "trash"); Text("Eliminar Materia") }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color(hex: "#D32F2F").opacity(0.1))
                .foregroundColor(Color(hex: "#D32F2F")).cornerRadius(12)
        }
    }
}
