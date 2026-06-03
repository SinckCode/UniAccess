import SwiftUI

struct DashboardView: View {
    @AppStorage("userName") private var userName = "Usuario"

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    private let entidades: [(String, String, Color, AnyView)] = [
        ("Carreras", "graduationcap.fill", Color(hex: "#1B2A4A"), AnyView(CarreraListView())),
        ("Profesores", "person.text.rectangle", Color(hex: "#2E7D32"), AnyView(ProfesorListView())),
        ("Alumnos", "person.3.fill", Color(hex: "#00897B"), AnyView(AlumnoListView())),
        ("Materias", "book.fill", Color(hex: "#F9A825"), AnyView(MateriaListView())),
        ("Directivos", "briefcase.fill", Color(hex: "#D32F2F"), AnyView(DirectivoListView())),
        ("Staff", "wrench.and.screwdriver.fill", Color(hex: "#6B7280"), AnyView(StaffListView()))
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                headerSection
                managementCard
                Text("Accesos Rapidos")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#1A1A1A"))
                    .padding(.horizontal)

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(entidades, id: \.0) { entidad in
                        NavigationLink(destination: entidad.3) {
                            StatCard(icon: entidad.1, value: "", label: entidad.0, color: entidad.2)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Inicio")
        .navigationBarTitleDisplayMode(.large)
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hola, \(userName.components(separatedBy: "@").first ?? userName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "#1A1A1A"))
                Text(Date.now.formatted(date: .long, time: .omitted))
                    .font(.subheadline)
                    .foregroundColor(Color(hex: "#6B7280"))
            }
            Spacer()
            Image(systemName: "bell.fill")
                .foregroundColor(Color(hex: "#1B2A4A"))
                .font(.title3)
        }
        .padding(.horizontal)
    }

    private var managementCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 52, height: 52)
                Image(systemName: "building.columns.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Gestion Academica")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("Sistema de administracion institucional")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: [Color(hex: "#1B2A4A"), Color(hex: "#2E3F6F")],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(16)
        .padding(.horizontal)
    }
}
