import SwiftUI

struct MisMateriasAlumnoView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = MateriaViewModel()
    @StateObject private var alumnoVM = AlumnoViewModel()
    @StateObject private var profesorVM = ProfesorViewModel()

    private var alumno: Alumno? {
        alumnoVM.alumnos.first { $0.idAlumno == session.entityId }
    }

    private var misMaterias: [Materia] {
        guard let a = alumno else { return [] }
        return vm.materias.filter { $0.idCarrera == a.idCarrera && $0.semestre == a.semestre }
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if misMaterias.isEmpty {
                ContentUnavailableView("Sin materias", systemImage: "book.fill", description: Text("No hay materias para tu semestre"))
            } else {
                List {
                    ForEach(misMaterias) { materia in
                        CardView {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(materia.nombre).font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                                Text("Clave: \(materia.clave)").font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                                HStack {
                                    Text("\(materia.creditos) creditos").font(.caption).foregroundColor(Color(hex: "#00897B"))
                                    Spacer()
                                    let prof = profesorVM.profesores.first { $0.idProfesor == materia.idProfesor }
                                    Text(prof?.nombreCompleto ?? "Profesor").font(.caption).foregroundColor(Color(hex: "#6B7280"))
                                }
                            }
                        }
                        .padding(.horizontal).padding(.vertical, 4)
                        .listRowBackground(Color.clear).listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain).background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Mis Materias")
        .background(Color(hex: "#F5F5F7"))
        .task {
            await vm.fetchAll()
            await alumnoVM.fetchAll()
            await profesorVM.fetchAll()
        }
    }
}
