import SwiftUI

struct CarreraListView: View {
    @StateObject private var vm = CarreraViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Carrera] {
        searchText.isEmpty ? vm.carreras : vm.carreras.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.facultad.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin carreras", systemImage: "graduationcap.fill", description: Text(searchText.isEmpty ? "No hay carreras registradas" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { carrera in
                        NavigationLink(destination: CarreraDetailView(carrera: carrera, vm: vm)) {
                            CarreraRowView(carrera: carrera)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idCarrera {
                                Task { await vm.delete(id: id) }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Carreras")
        .searchable(text: $searchText, prompt: "Buscar carrera...")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showForm = true } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showForm) {
            CarreraFormView(vm: vm)
        }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(vm.errorMessage ?? "")
        }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct CarreraRowView: View {
    let carrera: Carrera

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#1B2A4A").opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "graduationcap.fill")
                        .foregroundColor(Color(hex: "#1B2A4A"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(carrera.nombre)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#1A1A1A"))
                    Text(carrera.facultad)
                        .font(.subheadline)
                        .foregroundColor(Color(hex: "#6B7280"))
                    Text("\(carrera.duracionSemestres) semestres")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#00897B"))
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
