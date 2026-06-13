import SwiftUI

struct HorarioAlumnoView: View {
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
                ContentUnavailableView(
                    "Sin horario",
                    systemImage: "calendar",
                    description: Text("No hay materias asignadas para tu semestre")
                )
            } else {
                ScrollView {
                    VStack(spacing: 12) {
                        HStack(spacing: 12) {
                            StatCard(
                                icon: "book.fill",
                                value: "\(misMaterias.count)",
                                label: "Materias",
                                color: Color(hex: "#1B2A4A")
                            )
                            StatCard(
                                icon: "calendar",
                                value: "Sem \(alumno?.semestre ?? 0)",
                                label: "Semestre actual",
                                color: Color(hex: "#00897B")
                            )
                        }
                        .padding(.horizontal)

                        ForEach(misMaterias) { materia in
                            materiaCard(materia)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
                .background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Horario")
        .background(Color(hex: "#F5F5F7"))
        .task {
            await vm.fetchAll()
            await alumnoVM.fetchAll()
            await profesorVM.fetchAll()
        }
    }

    private func materiaCard(_ materia: Materia) -> some View {
        CardView {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "#1B2A4A").opacity(0.1))
                        .frame(width: 52, height: 52)
                    Image(systemName: "book.fill")
                        .font(.title3)
                        .foregroundColor(Color(hex: "#1B2A4A"))
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text(materia.nombre)
                        .font(.subheadline).fontWeight(.semibold)
                        .foregroundColor(Color(hex: "#1A1A1A"))

                    if let dia = materia.diaSemana, !dia.isEmpty {
                        Label(dia, systemImage: "calendar")
                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }

                    if let hora = materia.hora, !hora.isEmpty {
                        Label(hora, systemImage: "clock")
                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }

                    let prof = profesorVM.profesores.first { $0.idProfesor == materia.idProfesor }
                    if let nombre = prof?.nombreCompleto {
                        Label(nombre, systemImage: "person.fill")
                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(materia.clave)
                        .font(.caption).fontWeight(.medium)
                        .foregroundColor(Color(hex: "#00897B"))
                    Text("\(materia.creditos) cred.")
                        .font(.caption2).foregroundColor(Color(hex: "#6B7280"))
                }
            }
        }
    }
}
