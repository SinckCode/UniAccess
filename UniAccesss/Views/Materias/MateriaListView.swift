import SwiftUI

struct MateriaListView: View {
    @StateObject private var vm = MateriaViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Materia] {
        searchText.isEmpty ? vm.materias : vm.materias.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.clave.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin materias", systemImage: "book.fill", description: Text(searchText.isEmpty ? "No hay materias registradas" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { materia in
                        NavigationLink(destination: MateriaDetailView(materia: materia, vm: vm)) {
                            MateriaRowView(materia: materia)
                        }
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idMateria { Task { await vm.delete(id: id) } }
                        }
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Materias")
        .searchable(text: $searchText, prompt: "Buscar materia...")
        .toolbar { ToolbarItem(placement: .primaryAction) { Button { showForm = true } label: { Image(systemName: "plus") } } }
        .sheet(isPresented: $showForm) { MateriaFormView(vm: vm) }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct MateriaRowView: View {
    let materia: Materia

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#F9A825").opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: "book.fill")
                        .foregroundColor(Color(hex: "#F9A825"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(materia.nombre).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                    Text("Clave: \(materia.clave)").font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    Text("\(materia.creditos) creditos · Sem \(materia.semestre)").font(.caption).foregroundColor(Color(hex: "#00897B"))
                }
                Spacer()
            }
        }
        .padding(.horizontal).padding(.vertical, 4)
    }
}
