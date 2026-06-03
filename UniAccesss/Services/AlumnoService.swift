import Foundation

class AlumnoService {
    private let endpoint = "alumnos"
    private let api = APIService.shared

    func getAll() async throws -> [Alumno] { try await api.getAll(endpoint: endpoint) }
    func getById(id: Int) async throws -> Alumno { try await api.getById(endpoint: endpoint, id: id) }
    func save(_ item: Alumno) async throws { try await api.save(endpoint: endpoint, body: item) }
    func update(_ item: Alumno) async throws { try await api.update(endpoint: endpoint, body: item) }
    func delete(id: Int) async throws { try await api.delete(endpoint: endpoint, id: id) }
}
