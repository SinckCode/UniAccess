import SwiftUI

struct ProfesorDashboardView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var profesorVM = ProfesorViewModel()
    @StateObject private var materiaVM  = MateriaViewModel()

    private var profesor: Profesor? {
        profesorVM.profesores.first { $0.idProfesor == session.entityId }
    }
    private var misMaterias: [Materia] {
        materiaVM.materias.filter { $0.idProfesor == session.entityId }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hola, \(session.nombre)")
                        .font(.title2).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(Date.now.formatted(date: .long, time: .omitted))
                        .font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                }

                HStack(spacing: 12) {
                    StatCard(icon: "book.fill", value: "\(misMaterias.count)", label: "Materias asignadas", color: Color(hex: "#2E7D32"))
                    StatCard(icon: "star.fill", value: profesor?.especialidad ?? "—", label: "Especialidad", color: Color(hex: "#1B2A4A"))
                }

                if !misMaterias.isEmpty {
                    CardView {
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Mis Materias").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                            Divider()
                            ForEach(misMaterias) { m in
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(m.nombre).font(.subheadline).fontWeight(.medium)
                                        Text("Sem \(m.semestre) · \(m.creditos) cred").font(.caption).foregroundColor(Color(hex: "#6B7280"))
                                    }
                                    Spacer()
                                    Text(m.clave).font(.caption).foregroundColor(Color(hex: "#00897B"))
                                }
                                if m.id != misMaterias.last?.id { Divider() }
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Inicio")
        .task { await profesorVM.fetchAll(); await materiaVM.fetchAll() }
    }
}
