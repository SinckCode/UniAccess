import Foundation
import SwiftUI

@MainActor
class CalificacionViewModel: ObservableObject {
    @Published var calificaciones: [Calificacion] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = CalificacionService()

    func fetchByAlumno(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        do {
            calificaciones = try await service.getByAlumno(id: id)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Calificacion) async {
        do {
            try await service.save(item)
            if let idAlumno = calificaciones.first?.idAlumno ?? (item.idAlumno != 0 ? item.idAlumno : nil) {
                await fetchByAlumno(id: idAlumno)
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Calificacion) async {
        do {
            try await service.update(item)
            if item.idAlumno != 0 { await fetchByAlumno(id: item.idAlumno) }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func delete(id: Int, idAlumno: Int) async {
        do {
            try await service.delete(id: id)
            calificaciones.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
