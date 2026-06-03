import SwiftUI

struct MisMateriasProfesorView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = MateriaViewModel()

    private var misMaterias: [Materia] {
        vm.materias.filter { $0.idProfesor == session.entityId }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if misMaterias.isEmpty {
                ContentUnavailableView("Sin materias asignadas", systemImage: "book.fill", description: Text("No tienes materias asignadas"))
            } else {
                List {
                    ForEach(misMaterias) { materia in
                        NavigationLink(destination: MateriaDetailView(materia: materia, vm: vm)) {
                            CardView {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(materia.nombre).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                                    Text("Clave: \(materia.clave)").font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                                    Text("Semestre \(materia.semestre) · \(materia.creditos) creditos").font(.caption).foregroundColor(Color(hex: "#00897B"))
                                }
                            }
                            .padding(.horizontal).padding(.vertical, 4)
                        }
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Mis Materias")
        .background(Color(hex: "#F5F5F7"))
        .task { await vm.fetchAll() }
    }
}
