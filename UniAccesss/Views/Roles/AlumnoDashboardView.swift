import SwiftUI

struct AlumnoDashboardView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var carreraVM = CarreraViewModel()
    @StateObject private var materiaVM = MateriaViewModel()
    @StateObject private var alumnoVM  = AlumnoViewModel()

    private var alumno: Alumno? {
        alumnoVM.alumnos.first { $0.idAlumno == session.entityId }
    }
    private var carrera: Carrera? {
        carreraVM.carreras.first { $0.idCarrera == alumno?.idCarrera }
    }
    private var misMateriasCount: Int {
        materiaVM.materias.filter {
            $0.idCarrera == (alumno?.idCarrera ?? 0) &&
            $0.semestre  == (alumno?.semestre ?? 0)
        }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                statsRow
                infoCard
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Inicio")
        .task {
            await carreraVM.fetchAll()
            await materiaVM.fetchAll()
            await alumnoVM.fetchAll()
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Hola, \(session.nombre) 👋")
                .font(.title2).fontWeight(.bold)
                .foregroundColor(Color(hex: "#1A1A1A"))
            Text(Date.now.formatted(date: .long, time: .omitted))
                .font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
        }
    }

    private var statsRow: some View {
        HStack(spacing: 12) {
            StatCard(icon: "number", value: alumno?.matricula ?? "—", label: "Matricula", color: Color(hex: "#1B2A4A"))
            StatCard(icon: "calendar", value: "Sem \(alumno?.semestre ?? 0)", label: "Semestre", color: Color(hex: "#2E7D32"))
            StatCard(icon: "book.fill", value: "\(misMateriasCount)", label: "Materias", color: Color(hex: "#00897B"))
        }
    }

    private var infoCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Mi Informacion").font(.headline).foregroundColor(Color(hex: "#1A1A1A"))
                Divider()
                row("Carrera", carrera?.nombre ?? "Cargando...")
                row("Facultad", carrera?.facultad ?? "—")
                if let est = alumno?.estatus { row("Estatus", est) }
                row("Correo", alumno?.correo ?? "—")
            }
        }
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.subheadline).foregroundColor(Color(hex: "#6B7280")).frame(width: 80, alignment: .leading)
            Text(value).font(.subheadline).fontWeight(.medium).foregroundColor(Color(hex: "#1A1A1A"))
            Spacer()
        }
    }
}
