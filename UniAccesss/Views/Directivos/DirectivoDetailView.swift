import SwiftUI

struct DirectivoDetailView: View {
    let directivo: Directivo
    @ObservedObject var vm: DirectivoViewModel
    @State private var showEditForm = false
    @State private var showDeleteAlert = false
    @Environment(\.dismiss) private var dismiss

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
        .navigationTitle("Detalle Directivo")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .primaryAction) { Button("Editar") { showEditForm = true } } }
        .sheet(isPresented: $showEditForm) { DirectivoFormView(vm: vm, directivo: directivo) }
        .alert("Eliminar Directivo", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = directivo.idDirectivo { Task { await vm.delete(id: id); dismiss() } }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color(hex: "#D32F2F").opacity(0.12)).frame(width: 64, height: 64)
                    Image(systemName: "briefcase.fill").font(.title).foregroundColor(Color(hex: "#D32F2F"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(directivo.nombreCompleto).font(.title3).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(directivo.puesto).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
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
                row("ID", "\(directivo.idDirectivo ?? 0)")
                row("Nombre", directivo.nombre)
                row("Ap. Paterno", directivo.apellidoPaterno)
                if let am = directivo.apellidoMaterno { row("Ap. Materno", am) }
                row("Puesto", directivo.puesto)
                row("Correo", directivo.correo)
                if let tel = directivo.telefono { row("Telefono", tel) }
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
            HStack { Image(systemName: "trash"); Text("Eliminar Directivo") }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color(hex: "#D32F2F").opacity(0.1))
                .foregroundColor(Color(hex: "#D32F2F")).cornerRadius(12)
        }
    }
}
