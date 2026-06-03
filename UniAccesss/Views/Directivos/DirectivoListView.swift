import SwiftUI

struct DirectivoListView: View {
    @StateObject private var vm = DirectivoViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Directivo] {
        searchText.isEmpty ? vm.directivos : vm.directivos.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.apellidoPaterno.localizedCaseInsensitiveContains(searchText) ||
            $0.puesto.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin directivos", systemImage: "briefcase.fill", description: Text(searchText.isEmpty ? "No hay directivos registrados" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { directivo in
                        NavigationLink(destination: DirectivoDetailView(directivo: directivo, vm: vm)) {
                            DirectivoRowView(directivo: directivo)
                        }
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idDirectivo { Task { await vm.delete(id: id) } }
                        }
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Directivos")
        .searchable(text: $searchText, prompt: "Buscar directivo...")
        .toolbar { ToolbarItem(placement: .primaryAction) { Button { showForm = true } label: { Image(systemName: "plus") } } }
        .sheet(isPresented: $showForm) { DirectivoFormView(vm: vm) }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct DirectivoRowView: View {
    let directivo: Directivo

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#D32F2F").opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "briefcase.fill").foregroundColor(Color(hex: "#D32F2F"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(directivo.nombreCompleto).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(directivo.puesto).font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                }
                Spacer()
            }
        }
        .padding(.horizontal).padding(.vertical, 4)
    }
}
