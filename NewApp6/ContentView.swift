
import SwiftUI
import Foundation
import Combine


struct Film: Codable, Identifiable {
    let id: String
    let title: String
    let description: String
    let director: String
    let producer: String
    let runningTime: String
    let releaseDate: String
    let image: URL

    enum CodingKeys: String, CodingKey {
        case id, title, description, director, producer, image
        case runningTime = "running_time"
        case releaseDate = "release_date"
    }
}


func fetchFilms() async throws -> [Film] {
    let url = URL(string: "https://ghibliapi.vercel.app/films")!
    let (data, _) = try await URLSession.shared.data(from: url)
    return try JSONDecoder().decode([Film].self, from: data)
}


@MainActor
class FilmViewModel: ObservableObject {
    @Published var films: [Film] = []
    @Published var favoriteFilmIDs: Set<String> = []

    var favoriteFilms: [Film] {
        films.filter { favoriteFilmIDs.contains($0.id) }
    }

    func loadFilms() {
        Task {
            do {
                films = try await fetchFilms()
            } catch {
                print(error)
            }
        }
    }

    func toggleFavorite(_ film: Film) {
        if favoriteFilmIDs.contains(film.id) {
            favoriteFilmIDs.remove(film.id)
        } else {
            favoriteFilmIDs.insert(film.id)
        }
    }

    func isFavorite(_ film: Film) -> Bool {
        favoriteFilmIDs.contains(film.id)
    }
}


struct MainTabView: View {
    @StateObject private var viewModel = FilmViewModel()

    var body: some View {
        TabView {
            FilmsView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            FavoriteView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorite")
                }

            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}


struct FilmsView: View {
    @ObservedObject var viewModel: FilmViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(viewModel.films) { film in
                        NavigationLink {
                            FilmDetailView(film: film)
                        } label: {
                            HStack {
                                AsyncImage(url: film.image) { image in
                                    image.resizable()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 60, height: 90)
                                .cornerRadius(8)

                                VStack(alignment: .leading, spacing: 6) {
                                    Text(film.title)
                                        .font(.headline)
                                    Text(film.director)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button {
                                    viewModel.toggleFavorite(film)
                                } label: {
                                    Image(systemName: viewModel.isFavorite(film) ? "heart.fill" : "heart")
                                        .foregroundColor(.red)
                                }
                                .buttonStyle(.borderless)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Movies")
            .task {
                viewModel.loadFilms()
            }
        }
    }
}


struct FavoriteView: View {
    @ObservedObject var viewModel: FilmViewModel

    var body: some View {
        NavigationStack {
            List {
                if viewModel.favoriteFilms.isEmpty {
                    Text("No Films")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.favoriteFilms) { film in
                        HStack {
                            AsyncImage(url: film.image) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 60)
                            .cornerRadius(6)

                            VStack(alignment: .leading) {
                                Text(film.title).font(.headline)
                                Text(film.director)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Favorite")
        }
    }
}


struct FilmDetailView: View {
    let film: Film

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: film.image) { image in
                    image.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .cornerRadius(12)

                Text(film.title)
                    .font(.largeTitle)
                    .bold()

                Group {
                    Text("Director: \(film.director)")
                    Text("Producer: \(film.producer)")
                    Text("Running Time: \(film.runningTime) min")
                    Text("Release Date: \(film.releaseDate)")
                }
                .foregroundColor(.secondary)

                Text(film.description)
            }
            .padding()
        }
        .navigationTitle(film.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    MainTabView()
}
