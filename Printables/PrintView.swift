import SwiftUI
import Dependencies
import PrintablesKit

struct PrintView: View {
    @Dependency(\.apiClient) var apiClient
    @State private var text: String = "Hello, world!"
    @State private var print: Print?
    @State public var id: String
    
    var body: some View {
        VStack {
            if let print {
                VStack(alignment: .leading, spacing: 10) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(print.images) { url in
                                AsyncImage(url: url,
                                           content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                },
                                           placeholder: { ProgressView() }
                                )
                            }
                            .frame(height: 100)
                        }
                    }
                    Text(print.summary ?? "")
                    Text(print.description ?? "")
                    NavigationLink(destination: STLView(print: print)) {
                        Text("Show STL")
                    }
                    Spacer()
                }
                .navigationTitle(print.name)
                .padding()
            } else {
                ProgressView()
            }
        }
        .onAppear(perform: loadPrint)
    }
    
    func loadPrint() {
        Task {
            print = try await apiClient.print(id)
        }
    }
}

struct PrintView_Previews: PreviewProvider {
    static var previews: some View {
        PrintView(id: Print.preview(0).id)
    }
}

extension URL: Identifiable {
    public var id: URL { self }
}
