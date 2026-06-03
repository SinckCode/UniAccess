import Foundation
import SwiftUI
import Combine

@MainActor
class CarreraViewModel: ObservableObject {
    @Published var carreras: [Carrera] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false

    private let service = CarreraService()

    func fetchAll() async {
        isLoading = true
        defer { isLoading = false }
        do {
            carreras = try await service.getAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func save(_ item: Carrera) async {
        do {
            try await service.save(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func update(_ item: Carrera) async {
        do {
            try await service.update(item)
            await fetchAll()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func delete(id: Int) async {
        do {
            try await service.delete(id: id)
            carreras.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
