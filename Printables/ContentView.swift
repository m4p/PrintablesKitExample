import SwiftUI
import Dependencies
import PrintablesKit

struct ContentView: View {
    @Dependency(\.apiClient) var apiClient

    @State private var prints = [Print]()
    @State public var searchText: String
    
    var body: some View {
        NavigationStack {
            List(prints) { print in
                NavigationLink(value: print) {
                    PrintSearchResultView(print: print)
                }
            }
            .navigationTitle("PrintablesKit Example")
            .navigationDestination(for: Print.self) { print in
                PrintView(id: print.id)
            }
        }
        .searchable(text: $searchText)
        .onSubmit(of: .search, runSearch)
        .onAppear(perform: runSearch)
    }
    
    func runSearch() {
        Task {
            guard !searchText.isEmpty else {
                prints = []
                return
            }
            let items = try await apiClient.search(query: searchText, limit: 20)
            prints = items
        }
    }

}

struct PrintSearchResultView: View {
    @State public var print: Print
    
    var body: some View {
        HStack(spacing: 20) {
            AsyncImage(url: print.images.first,
                       content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        },
                       placeholder: { ProgressView() }
            )
            .frame(width: 100, height: 100)

            Text(print.name)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(searchText: "Test")
    }
}
