import SwiftUI

struct StaffListView: View {
    @StateObject private var vm = StaffViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Staff] {
        searchText.isEmpty ? vm.staffList : vm.staffList.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.apellidoPaterno.localizedCaseInsensitiveContains(searchText) ||
            $0.area.localizedCaseInsensitiveContains(searchText) ||
            $0.puesto.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin staff", systemImage: "wrench.and.screwdriver.fill", description: Text(searchText.isEmpty ? "No hay staff registrado" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { staff in
                        NavigationLink(destination: StaffDetailView(staff: staff, vm: vm)) {
                            StaffRowView(staff: staff)
                        }
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idStaff { Task { await vm.delete(id: id) } }
                        }
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Staff")
        .searchable(text: $searchText, prompt: "Buscar staff...")
        .toolbar { ToolbarItem(placement: .primaryAction) { Button { showForm = true } label: { Image(systemName: "plus") } } }
        .sheet(isPresented: $showForm) { StaffFormView(vm: vm) }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct StaffRowView: View {
    let staff: Staff

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#6B7280").opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: "wrench.and.screwdriver.fill").foregroundColor(Color(hex: "#6B7280"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(staff.nombreCompleto).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(staff.puesto).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    Text(staff.area).font(.caption).foregroundColor(Color(hex: "#00897B"))
                }
                Spacer()
            }
        }
        .padding(.horizontal).padding(.vertical, 4)
    }
}
