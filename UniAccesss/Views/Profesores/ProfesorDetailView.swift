import SwiftUI

struct ProfesorDetailView: View {
    let profesor: Profesor
    @ObservedObject var vm: ProfesorViewModel
    @State private var showEditForm = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                infoCard
                contactCard
                deleteButton
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Detalle Profesor")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Editar") { showEditForm = true }
            }
        }
        .sheet(isPresented: $showEditForm) { ProfesorFormView(vm: vm, profesor: profesor) }
        .alert("Eliminar Profesor", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = profesor.idProfesor {
                    Task { await vm.delete(id: id); dismiss() }
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#2E7D32").opacity(0.12))
                        .frame(width: 64, height: 64)
                    Image(systemName: "person.text.rectangle")
                        .font(.title)
                        .foregroundColor(Color(hex: "#2E7D32"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(profesor.nombreCompleto)
                        .font(.title3).fontWeight(.bold)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    if let esp = profesor.especialidad {
                        Text(esp).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    }
                    if let est = profesor.estatus { StatusBadge(text: est) }
                }
                Spacer()
            }
        }
    }

    private var infoCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Datos Personales").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("ID", "\(profesor.idProfesor ?? 0)")
                row("Nombre", profesor.nombre)
                row("Ap. Paterno", profesor.apellidoPaterno)
                if let am = profesor.apellidoMaterno { row("Ap. Materno", am) }
                if let esp = profesor.especialidad { row("Especialidad", esp) }
            }
        }
    }

    private var contactCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Contacto").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("Correo", profesor.correo)
                if let tel = profesor.telefono { row("Telefono", tel) }
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
            HStack {
                Image(systemName: "trash")
                Text("Eliminar Profesor")
            }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background(Color(hex: "#D32F2F").opacity(0.1))
            .foregroundColor(Color(hex: "#D32F2F")).cornerRadius(12)
        }
    }
}
