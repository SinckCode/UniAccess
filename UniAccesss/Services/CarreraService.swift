import Foundation

class CarreraService {
    private let endpoint = "carreras"
    private let api = APIService.shared

    func getAll() async throws -> [Carrera] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Carrera { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Carrera) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Carrera) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
