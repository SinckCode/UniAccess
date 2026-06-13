import Foundation

class CalificacionService {
    private let endpoint = "calificaciones"
    private let api = APIService.shared

    func getAll() async throws -> [Calificacion] { try await api.getAll(endpoint: endpoint) }
    func getByAlumno(id: Int) async throws -> [Calificacion] { try await api.getList(path: "\(endpoint)/getByAlumno/\(id)") }
    func save(_ item: Calificacion) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Calificacion) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
