import Foundation

class ProfesorService {
    private let endpoint = "profesores"
    private let api = APIService.shared

    func getAll() async throws -> [Profesor] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Profesor { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Profesor) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Profesor) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
