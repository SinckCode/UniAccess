import SwiftUI

struct AdminMenuView: View {
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    private let entidades: [(String, String, Color, AnyView)] = [
        ("Carreras",   "graduationcap.fill",          Color(hex: "#1B2A4A"), AnyView(CarreraListView())),
        ("Profesores", "person.text.rectangle",       Color(hex: "#2E7D32"), AnyView(ProfesorListView())),
        ("Alumnos",    "person.3.fill",               Color(hex: "#00897B"), AnyView(AlumnoListView())),
        ("Materias",   "book.fill",                   Color(hex: "#F9A825"), AnyView(MateriaListView())),
        ("Directivos", "briefcase.fill",              Color(hex: "#D32F2F"), AnyView(DirectivoListView())),
        ("Staff",      "wrench.and.screwdriver.fill", Color(hex: "#6B7280"), AnyView(StaffListView()))
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Selecciona una entidad para administrar")
                    .font(.subheadline).foregroundColor(Color(hex: "#6B7280"))

                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(entidades, id: \.0) { entidad in
                        NavigationLink(destination: entidad.3) {
                            StatCard(icon: entidad.1, value: "", label: entidad.0, color: entidad.2)
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color(hex: "#F5F5F7"))
        .navigationTitle("Gestion")
    }
}
