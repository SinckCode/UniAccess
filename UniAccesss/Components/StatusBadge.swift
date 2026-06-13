import SwiftUI

struct StatusBadge: View {
    let text: String

    private var color: Color {
        switch text.lowercased() {
        case "activo":    return Color(hex: "#2E7D32")
        case "inactivo":  return Color(hex: "#D32F2F")
        case "aprobado":  return Color(hex: "#2E7D32")
        case "reprobado": return Color(hex: "#D32F2F")
        default:          return Color(hex: "#F9A825")
        }
    }

    var body: some View {
        Text(text.capitalized)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(20)
    }
}
