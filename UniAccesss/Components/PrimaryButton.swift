import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var color: Color = Color(hex: "#2E7D32")

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.9)
                }
                Text(isLoading ? "Cargando..." : title)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(isLoading ? color.opacity(0.7) : color)
            .cornerRadius(12)
        }
        .disabled(isLoading)
    }
}
