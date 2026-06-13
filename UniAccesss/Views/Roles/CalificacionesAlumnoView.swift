import SwiftUI

struct CalificacionesAlumnoView: View {
    @EnvironmentObject private var session: UserSession
    @StateObject private var vm = CalificacionViewModel()
    @StateObject private var materiaVM = MateriaViewModel()

    private var promedio: Double {
        guard !vm.calificaciones.isEmpty else { return 0 }
        return vm.calificaciones.reduce(0) { $0 + $1.calificacion } / Double(vm.calificaciones.count)
    }

    var body: some View {
        Group {
            if vm.isLoading {
                ProgressView("Cargando...").frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if vm.calificaciones.isEmpty {
                ContentUnavailableView(
                    "Sin calificaciones",
                    systemImage: "checkmark.seal",
                    description: Text("No hay calificaciones registradas para este periodo")
                )
            } else {
                List {
                    Section {
                        HStack(spacing: 16) {
                            StatCard(
                                icon: "chart.bar.fill",
                                value: String(format: "%.1f", promedio),
                                label: "Promedio",
                                color: colorPromedio(promedio)
                            )
                            StatCard(
                                icon: "book.fill",
                                value: "\(vm.calificaciones.count)",
                                label: "Materias",
                                color: Color(hex: "#1B2A4A")
                            )
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 4)
                    }

                    Section("Detalle por materia") {
                        ForEach(vm.calificaciones) { cal in
                            let materia = materiaVM.materias.first { $0.idMateria == cal.idMateria }
                            CardView {
                                HStack(spacing: 12) {
                                    ZStack {
                                        Circle()
                                            .fill(colorCalificacion(cal.calificacion).opacity(0.15))
                                            .frame(width: 50, height: 50)
                                        Text(String(format: "%.1f", cal.calificacion))
                                            .font(.headline).fontWeight(.bold)
                                            .foregroundColor(colorCalificacion(cal.calificacion))
                                    }
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(materia?.nombre ?? "Materia \(cal.idMateria)")
                                            .font(.subheadline).fontWeight(.semibold)
                                            .foregroundColor(Color(hex: "#1A1A1A"))
                                        Text(materia?.clave ?? "—")
                                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                                        Text("Periodo: \(cal.periodo)")
                                            .font(.caption).foregroundColor(Color(hex: "#6B7280"))
                                    }
                                    Spacer()
                                    StatusBadge(text: cal.aprobado ? "Aprobado" : "Reprobado")
                                }
                            }
                            .padding(.horizontal).padding(.vertical, 4)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color(hex: "#F5F5F7"))
            }
        }
        .navigationTitle("Calificaciones")
        .background(Color(hex: "#F5F5F7"))
        .task {
            await vm.fetchByAlumno(id: session.entityId)
            await materiaVM.fetchAll()
        }
        .alert("Error", isPresented: $vm.showError) {
            Button("OK", role: .cancel) {}
        } message: { Text(vm.errorMessage ?? "") }
    }

    private func colorCalificacion(_ cal: Double) -> Color {
        if cal >= 9 { return Color(hex: "#2E7D32") }
        if cal >= 7 { return Color(hex: "#00897B") }
        if cal >= 6 { return Color(hex: "#F9A825") }
        return Color(hex: "#D32F2F")
    }

    private func colorPromedio(_ p: Double) -> Color {
        if p >= 9 { return Color(hex: "#2E7D32") }
        if p >= 7 { return Color(hex: "#00897B") }
        if p >= 6 { return Color(hex: "#F9A825") }
        return Color(hex: "#D32F2F")
    }
}
