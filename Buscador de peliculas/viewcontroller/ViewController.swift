import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    let movieService = MovieService()
    var movies: [MovieSearchItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
        fetchInitialMovies()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar película..."
    }

    func fetchInitialMovies() {
        fetchMovies(query: "matrix")
    }

    func fetchMovies(query: String) {
        movieService.fetchMovies(searchText: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    self?.movies = movies
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        let movie = movies[indexPath.row]

        cell.titleLabel.text = movie.Title
        cell.yearLabel.text = movie.Year

        // 👇 NUEVA carga de imagen usando tu extensión
        if movie.Poster != "N/A" {
            cell.posterImageView.loadFrom(url: movie.Poster)
        } else {
            cell.posterImageView.image = UIImage(systemName: "photo")
        }

        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            guard let dest = segue.destination as? DetailViewController,
                  let indexPath = tableView.indexPathForSelectedRow else { return }

            let movie = movies[indexPath.row]
            dest.imdbID = movie.imdbID
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        guard let text = searchBar.text, !text.isEmpty else { return }

        fetchMovies(query: text)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchText.count < 3 {
            return
        }

        fetchMovies(query: searchText)
    }
}
