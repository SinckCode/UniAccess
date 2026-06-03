import SwiftUI

struct CarreraFormView: View {
    @ObservedObject var vm: CarreraViewModel
    var carrera: Carrera? = nil
    @Environment(\.dismiss) private var dismiss

    @State private var nombre = ""
    @State private var descripcion = ""
    @State private var duracion = 9
    @State private var facultad = ""

    private var isEditing: Bool { carrera != nil }

    var body: some View {
        NavigationStack {
            Form {
                Section("Datos de la Carrera") {
                    StyledTextField(label: "Nombre", placeholder: "Ingenieria en Sistemas", icon: "graduationcap", text: $nombre)
                    StyledTextField(label: "Descripcion", placeholder: "Siglas o descripcion corta", icon: "text.alignleft", text: $descripcion)
                    StyledTextField(label: "Facultad", placeholder: "Ingenieria", icon: "building.columns", text: $facultad)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                Section("Duracion") {
                    Picker("Semestres", selection: $duracion) {
                        ForEach(1...12, id: \.self) { s in
                            Text("\(s) semestres").tag(s)
                        }
                    }
                    .pickerStyle(.wheel)
                }

                Section {
                    PrimaryButton(title: isEditing ? "Actualizar" : "Guardar", action: guardar, isLoading: vm.isLoading)
                }
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
            }
            .navigationTitle(isEditing ? "Editar Carrera" : "Nueva Carrera")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
            }
            .onAppear(perform: cargarDatos)
            .alert("Error", isPresented: $vm.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(vm.errorMessage ?? "")
            }
        }
    }

    private func cargarDatos() {
        guard let c = carrera else { return }
        nombre = c.nombre
        descripcion = c.descripcion
        duracion = c.duracionSemestres
        facultad = c.facultad
    }

    private func guardar() {
        guard !nombre.isEmpty, !facultad.isEmpty else { return }
        let item = Carrera(idCarrera: carrera?.idCarrera, nombre: nombre, descripcion: descripcion, duracionSemestres: duracion, facultad: facultad)
        Task {
            if isEditing {
                await vm.update(item)
            } else {
                await vm.save(item)
            }
            if !vm.showError { dismiss() }
        }
    }
}
