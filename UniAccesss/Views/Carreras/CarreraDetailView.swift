import SwiftUI

struct CarreraDetailView: View {
    let carrera: Carrera
    @ObservedObject var vm: CarreraViewModel
    @State private var showEditForm = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                infoCard
                actionButtons
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Detalle Carrera")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Editar") { showEditForm = true }
            }
        }
        .sheet(isPresented: $showEditForm) {
            CarreraFormView(vm: vm, carrera: carrera)
        }
        .alert("Eliminar Carrera", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = carrera.idCarrera {
                    Task {
                        await vm.delete(id: id)
                        dismiss()
                    }
                }
            }
            Button("Cancelar", role: .cancel) {}
        } message: {
            Text("Esta accion no se puede deshacer.")
        }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(hex: "#1B2A4A").opacity(0.12))
                        .frame(width: 64, height: 64)
                    Image(systemName: "graduationcap.fill")
                        .font(.title)
                        .foregroundColor(Color(hex: "#1B2A4A"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(carrera.nombre)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    Text(carrera.facultad)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#6B7280"))
                }
                Spacer()
            }
        }
    }

    private var infoCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Informacion General")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                infoRow(label: "ID", value: "\(carrera.idCarrera ?? 0)")
                infoRow(label: "Descripcion", value: carrera.descripcion)
                infoRow(label: "Duracion", value: "\(carrera.duracionSemestres) semestres")
                infoRow(label: "Facultad", value: carrera.facultad)
            }
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(Color(hex: "#6B7280"))
                .frame(width: 100, alignment: .leading)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(Color(hex: "#1A1A1A"))
            Spacer()
        }
    }

    private var actionButtons: some View {
        Button(role: .destructive) {
            showDeleteAlert = true
        } label: {
            HStack {
                Image(systemName: "trash")
                Text("Eliminar Carrera")
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color(hex: "#D32F2F").opacity(0.1))
            .foregroundColor(Color(hex: "#D32F2F"))
            .cornerRadius(12)
        }
    }
}
