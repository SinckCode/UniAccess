import SwiftUI

struct ProfesorFormView: View {
    @ObservedObject var vm: ProfesorViewModel
    var profesor: Profesor? = nil
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var apellidoPaterno = ""
    @State private var apellidoMaterno = ""
    @State private var correo = ""
    @State private var telefono = ""
    @State private var especialidad = ""
    @State private var activo = true

    private var isEditing: Bool { profesor != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Nombre") {
                    StyledTextField(label: "Nombre", placeholder: "Roberto", icon: "person", text: $nombre)
                    StyledTextField(label: "Apellido Paterno", placeholder: "Almanza", icon: "person", text: $apellidoPaterno)
                    StyledTextField(label: "Apellido Materno", placeholder: "Garcia (opcional)", icon: "person", text: $apellidoMaterno)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Contacto") {
                    StyledTextField(label: "Correo", placeholder: "r.almanza@uniaccess.edu", icon: "envelope", text: $correo, keyboardType: .emailAddress)
                    StyledTextField(label: "Telefono", placeholder: "5555001234 (opcional)", icon: "phone", text: $telefono, keyboardType: .phonePad)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section("Profesional") {
                    StyledTextField(label: "Especialidad", placeholder: "Ingenieria Civil (opcional)", icon: "star", text: $especialidad)
                    if isEditing {
                        Toggle("Estatus: Activo", isOn: $activo)
                            .tint(Color(hex: "#2E7D32"))
                    }
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear).listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Profesor" : "Nuevo Profesor")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) {}
            } message: { Text(vm.errorMessage ?? "") }
        }
    }

    private func cargarDatos() {
        guard let p = profesor else { return }
        nombre = p.nombre
        apellidoPaterno = p.apellidoPaterno
        apellidoMaterno = p.apellidoMaterno ?? ""
        correo = p.correo
        telefono = p.telefono ?? ""
        especialidad = p.especialidad ?? ""
        activo = (p.estatus ?? "activo") == "activo"
    }

    private func guardar() {
        guard !nombre.isEmpty, !apellidoPaterno.isEmpty, !correo.isEmpty else { return }
        let item = Profesor(
            idProfesor: profesor?.idProfesor,
            nombre: nombre,
            apellidoPaterno: apellidoPaterno,
            apellidoMaterno: apellidoMaterno.isEmpty ? nil : apellidoMaterno,
            correo: correo,
            telefono: telefono.isEmpty ? nil : telefono,
            especialidad: especialidad.isEmpty ? nil : especialidad,
            estatus: activo ? "activo" : "inactivo"
        )
        Task {
            if isEditing { await vm.update(item) } else { await vm.save(item) }
            if !vm.showError { dismiss() }
        }
    }
}
