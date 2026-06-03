import SwiftUI

struct StaffDetailView: View {
    let staff: Staff
    @ObservedObject var vm: StaffViewModel
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
        .navigationTitle("Detalle Staff")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .primaryAction) { Button("Editar") { showEditForm = true } } }
        .sheet(isPresented: $showEditForm) { StaffFormView(vm: vm, staff: staff) }
        .alert("Eliminar Staff", isPresented: $showDeleteAlert) {
            Button("Eliminar", role: .destructive) {
                if let id = staff.idStaff { Task { await vm.delete(id: id); dismiss() } }
            }
            Button("Cancelar", role: .cancel) {}
        } message: { Text("Esta accion no se puede deshacer.") }
    }

    private var headerCard: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color(hex: "#6B7280").opacity(0.12)).frame(width: 64, height: 64)
                    Image(systemName: "wrench.and.screwdriver.fill").font(.title).foregroundColor(Color(hex: "#6B7280"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(staff.nombreCompleto).font(.title3).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(staff.puesto).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    Text(staff.area).font(.caption).foregroundColor(Color(hex: "#00897B"))
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
                row("ID", "\(staff.idStaff ?? 0)")
                row("Nombre", staff.nombre)
                row("Ap. Paterno", staff.apellidoPaterno)
                if let am = staff.apellidoMaterno { row("Ap. Materno", am) }
                row("Area", staff.area)
                row("Puesto", staff.puesto)
                row("Correo", staff.correo)
                if let tel = staff.telefono { row("Telefono", tel) }
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
            HStack { Image(systemName: "trash"); Text("Eliminar Staff") }
                .frame(maxWidth: .infinity).padding(.vertical, 14)
                .background(Color(hex: "#D32F2F").opacity(0.1))
                .foregroundColor(Color(hex: "#D32F2F")).cornerRadius(12)
        }
    }
}
