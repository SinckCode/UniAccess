import SwiftUI

struct ProfesorListView: View {
    @StateObject private var vm = ProfesorViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Profesor] {
        searchText.isEmpty ? vm.profesores : vm.profesores.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.apellidoPaterno.localizedCaseInsensitiveContains(searchText) ||
            ($0.especialidad ?? "").localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin profesores", systemImage: "person.text.rectangle", description: Text(searchText.isEmpty ? "No hay profesores registrados" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { profesor in
                        NavigationLink(destination: ProfesorDetailView(profesor: profesor, vm: vm)) {
                            ProfesorRowView(profesor: profesor)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idProfesor {
                                Task { await vm.delete(id: id) }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Profesores")
        .searchable(text: $searchText, prompt: "Buscar profesor...")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showForm = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showForm) { ProfesorFormView(vm: vm) }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) {
            Button("OK", role: .cancel) {}
        } message: { Text(vm.errorMessage ?? "") }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct ProfesorRowView: View {
    let profesor: Profesor

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#2E7D32").opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.text.rectangle")
                        .foregroundColor(Color(hex: "#2E7D32"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(profesor.nombreCompleto)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    if let esp = profesor.especialidad {
                        Text(esp)
                            .font(.subheadline)
                            .foregroundColor(Color(hex: "#6B7280"))
                    }
                    if let est = profesor.estatus {
                        StatusBadge(text: est)
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
