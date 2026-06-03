import Foundation

class MateriaService {
    private let endpoint = "materias"
    private let api = APIService.shared

    func getAll() async throws -> [Materia] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Materia { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Materia) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Materia) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
