import SwiftUI

struct AlumnoListView: View {
    @StateObject private var vm = AlumnoViewModel()
    @State private var searchText = ""
    @State private var showForm = false

    private var filtered: [Alumno] {
        searchText.isEmpty ? vm.alumnos : vm.alumnos.filter {
            $0.nombre.localizedCaseInsensitiveContains(searchText) ||
            $0.apellidoPaterno.localizedCaseInsensitiveContains(searchText) ||
            $0.matricula.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if filtered.isEmpty {
                ContentUnavailableView("Sin alumnos", systemImage: "person.3.fill", description: Text(searchText.isEmpty ? "No hay alumnos registrados" : "No hay resultados"))
            } else {
                List {
                    ForEach(filtered) { alumno in
                        NavigationLink(destination: AlumnoDetailView(alumno: alumno, vm: vm)) {
                            AlumnoRowView(alumno: alumno)
                        }
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        offsets.forEach { i in
                            if let id = filtered[i].idAlumno { Task { await vm.delete(id: id) } }
                        }
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Alumnos")
        .searchable(text: $searchText, prompt: "Buscar alumno...")
        .toolbar { ToolbarItem(placement: .primaryAction) { Button { showForm = true } label: { Image(systemName: "plus") } } }
        .sheet(isPresented: $showForm) { AlumnoFormView(vm: vm) }
        .refreshable { await vm.fetchAll() }
        .task { await vm.fetchAll() }
        .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        .background(Color(hex: "#F5F5F7"))
    }
}

private struct AlumnoRowView: View {
    let alumno: Alumno

    var body: some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#00897B").opacity(0.1))
                        .frame(width: 44, height: 44)
                    Image(systemName: "person.3.fill")
                        .foregroundColor(Color(hex: "#00897B"))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(alumno.nombreCompleto).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                    Text("Mat: \(alumno.matricula)").font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    HStack(spacing: 8) {
                        Text("Sem \(alumno.semestre)").font(.caption).foregroundColor(Color(hex: "#00897B"))
                        if let est = alumno.estatus { StatusBadge(text: est) }
                    }
                }
                Spacer()
            }
        }
        .padding(.horizontal).padding(.vertical, 4)
    }
}
