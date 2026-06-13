import SwiftUI

struct MateriaFormView: View {
    @ObservedObject var vm: MateriaViewModel
    var materia: Materia? = nil
    @Environment(\.dismiss) private var dismiss
    @StateObject private var carreraVM = CarreraViewModel()
    @StateObject private var profesorVM = ProfesorViewModel()

    @State private var nombre = ""
    @State private var clave = ""
    @State private var creditos = 6
    @State private var semestre = 1
    @State private var idCarrera = 0
    @State private var idProfesor = 0
    @State private var diaSemana = ""
    @State private var hora = ""

    private var isEditing: Bool { materia != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos de la Materia") {
                    StyledTextField(label: "Nombre", placeholder: "Calculo Integral", icon: "book", text: $nombre)
                    StyledTextField(label: "Clave", placeholder: "MAT-201", icon: "number", text: $clave)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Detalles Academicos") {
                    Picker("Creditos", selection: $creditos) {
                        ForEach(1...12, id: \.self) { Text("\($0) creditos").tag($0) }
                    }
                    Picker("Semestre", selection: $semestre) {
                        ForEach(1...12, id: \.self) { Text("Semestre \($0)").tag($0) }
                    }
                    Picker("Carrera", selection: $idCarrera) {
                        Text("Seleccionar...").tag(0)
                        ForEach(carreraVM.carreras) { c in Text(c.nombre).tag(c.idCarrera ?? 0) }
                    }
                    Picker("Profesor", selection: $idProfesor) {
                        Text("Seleccionar...").tag(0)
                        ForEach(profesorVM.profesores) { p in Text(p.nombreCompleto).tag(p.idProfesor ?? 0) }
                    }
                }

                Section("Horario (opcional)") {
                    StyledTextField(label: "Dias", placeholder: "Lunes-Miercoles", icon: "calendar", text: $diaSemana)
                    StyledTextField(label: "Hora", placeholder: "08:00-10:00", icon: "clock", text: $hora)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Materia" : "Nueva Materia")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .task { await carreraVM.fetchAll(); await profesorVM.fetchAll() }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        }
    }

    private func cargarDatos() {
        guard let m = materia else { return }
        nombre = m.nombre; clave = m.clave; creditos = m.creditos
        semestre = m.semestre; idCarrera = m.idCarrera; idProfesor = m.idProfesor
        diaSemana = m.diaSemana ?? ""; hora = m.hora ?? ""
    }

    private func guardar() {
        guard !nombre.isEmpty, !clave.isEmpty, idCarrera != 0, idProfesor != 0 else { return }
        let item = Materia(
            idMateria: materia?.idMateria, nombre: nombre, clave: clave, creditos: creditos,
            semestre: semestre, idCarrera: idCarrera, idProfesor: idProfesor,
            diaSemana: diaSemana.isEmpty ? nil : diaSemana,
            hora: hora.isEmpty ? nil : hora
        )
        Task {
            if isEditing { await vm.update(item) } else { await vm.save(item) }
            if !vm.showError { dismiss() }
        }
    }
}
