import SwiftUI

struct AlumnoFormView: View {
    @ObservedObject var vm: AlumnoViewModel
    var alumno: Alumno? = nil
    @Environment(\.dismiss) private var dismiss
    @StateObject private var carreraVM = CarreraViewModel()

    @State private var nombre = ""
    @State private var apellidoPaterno = ""
    @State private var apellidoMaterno = ""
    @State private var matricula = ""
    @State private var correo = ""
    @State private var telefono = ""
    @State private var semestre = 1
    @State private var idCarreraSeleccionada = 0
    @State private var fechaIngreso = Date()
    @State private var activo = true

    private var isEditing: Bool { alumno != nil }
    private static let dateFormatter: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f
    }()

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre") {
                    StyledTextField(label: "Nombre", placeholder: "Alejandro", icon: "person", text: $nombre)
                    StyledTextField(label: "Apellido Paterno", placeholder: "Mendoza", icon: "person", text: $apellidoPaterno)
                    StyledTextField(label: "Apellido Materno (opcional)", placeholder: "Ruiz", icon: "person", text: $apellidoMaterno)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Datos Academicos") {
                    StyledTextField(label: "Matricula", placeholder: "202104593", icon: "number", text: $matricula)
                    Picker("Semestre", selection: $semestre) {
                        ForEach(1...12, id: \.self) { Text("Semestre \($0)").tag($0) }
                    }
                    Picker("Carrera", selection: $idCarreraSeleccionada) {
                        Text("Seleccionar...").tag(0)
                        ForEach(carreraVM.carreras) { c in
                            Text(c.nombre).tag(c.idCarrera ?? 0)
                        }
                    }
                    DatePicker("Fecha de Ingreso", selection: $fechaIngreso, displayedComponents: .date)
                    Toggle("Estatus: Activo", isOn: $activo).tint(Color(hex: "#2E7D32"))
                }

                Section("Contacto") {
                    StyledTextField(label: "Correo", placeholder: "a.mendoza@uniaccess.edu", icon: "envelope", text: $correo, keyboardType: .emailAddress)
                    StyledTextField(label: "Telefono (opcional)", placeholder: "5512345678", icon: "phone", text: $telefono, keyboardType: .phonePad)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Alumno" : "Nuevo Alumno")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .cancellationAction) { Button("Cancelar") { dismiss() } } }
            .task { await carreraVM.fetchAll() }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) { Button("OK", role: .cancel) {} } message: { Text(vm.errorMessage ?? "") }
        }
    }

    private func cargarDatos() {
        guard let a = alumno else { return }
        nombre = a.nombre; apellidoPaterno = a.apellidoPaterno
        apellidoMaterno = a.apellidoMaterno ?? ""; matricula = a.matricula
        correo = a.correo; telefono = a.telefono ?? ""
        semestre = a.semestre; idCarreraSeleccionada = a.idCarrera
        activo = (a.estatus ?? "activo") == "activo"
        if let d = AlumnoFormView.dateFormatter.date(from: a.fechaIngreso) { fechaIngreso = d }
    }

    private func guardar() {
        guard !nombre.isEmpty, !apellidoPaterno.isEmpty, !matricula.isEmpty, !correo.isEmpty, idCarreraSeleccionada != 0 else { return }
        let item = Alumno(
            idAlumno: alumno?.idAlumno, nombre: nombre, apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno.isEmpty ? nil : apellidoMaterno,
            matricula: matricula, correo: correo, telefono: telefono.isEmpty ? nil : telefono,
            semestre: semestre, idCarrera: idCarreraSeleccionada,
            fechaIngreso: AlumnoFormView.dateFormatter.string(from: fechaIngreso),
            estatus: activo ? "activo" : "inactivo"
        )
        Task {
            if isEditing { await vm.update(item) } else { await vm.save(item) }
            if !vm.showError { dismiss() }
        }
    }
}
