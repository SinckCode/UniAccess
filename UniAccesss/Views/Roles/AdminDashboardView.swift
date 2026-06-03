import SwiftUI

struct AdminDashboardView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var carreraVM   = CarreraViewModel()
    @StateObject private var profesorVM  = ProfesorViewModel()
    @StateObject private var alumnoVM    = AlumnoViewModel()
    @StateObject private var materiaVM   = MateriaViewModel()
    @StateObject private var directivoVM = DirectivoViewModel()
    @StateObject private var staffVM     = StaffViewModel()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hola, \(session.nombre)")
                        .font(.title2).fontWeight(.bold).foregroundColor(Color(hex: "#1A1A1A"))
                    Text(Date.now.formatted(date: .long, time: .omitted))
                        .font(.subheadline).foregroundColor(Color(hex: "#6B7280"))
                    Text(session.rol?.label ?? "")
                        .font(.caption).fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 10).padding(.vertical, 4)
                        .background(Color(hex: "#1B2A4A"))
                        .cornerRadius(20)
                }

                managementBanner

                Text("Estadisticas Generales")
                    .font(.headline).foregroundColor(Color(hex: "#1A1A1A"))

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    StatCard(icon: "graduationcap.fill",      value: "\(carreraVM.carreras.count)",      label: "Carreras",    color: Color(hex: "#1B2A4A"))
                    StatCard(icon: "person.text.rectangle",   value: "\(profesorVM.profesores.count)",   label: "Profesores",  color: Color(hex: "#2E7D32"))
                    StatCard(icon: "person.3.fill",           value: "\(alumnoVM.alumnos.count)",        label: "Alumnos",     color: Color(hex: "#00897B"))
                    StatCard(icon: "book.fill",               value: "\(materiaVM.materias.count)",      label: "Materias",    color: Color(hex: "#F9A825"))
                    StatCard(icon: "briefcase.fill",          value: "\(directivoVM.directivos.count)",  label: "Directivos",  color: Color(hex: "#D32F2F"))
                    StatCard(icon: "wrench.and.screwdriver.fill", value: "\(staffVM.staffList.count)",   label: "Staff",       color: Color(hex: "#6B7280"))
                }
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Dashboard")
        .task {
            await carreraVM.fetchAll()
            await profesorVM.fetchAll()
            await alumnoVM.fetchAll()
            await materiaVM.fetchAll()
            await directivoVM.fetchAll()
            await staffVM.fetchAll()
        }
    }

    private var managementBanner: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().fill(Color.white.opacity(0.2)).frame(width: 52, height: 52)
                Image(systemName: "building.columns.fill").font(.title2).foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Panel de Administracion").font(.title3).fontWeight(.bold).foregroundColor(.white)
                Text("Acceso completo al sistema").font(.caption).foregroundColor(.white.opacity(0.8))
            }
            Spacer()
        }
        .padding()
        .background(LinearGradient(colors: [Color(hex: "#1B2A4A"), Color(hex: "#2E3F6F")], startPoint: .leading, endPoint: .trailing))
        .cornerRadius(16)
    }
}
