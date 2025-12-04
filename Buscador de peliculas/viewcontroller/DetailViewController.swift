//
//  DetailViewController.swift
//  Buscador de peliculas
//
//  Created by Mananas on 4/12/25.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var sinopsisLabel: UILabel!

    var imdbID: String?

    let movieService = MovieService()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieDetail()
    }

    func loadMovieDetail() {
        guard let id = imdbID else { return }

        movieService.fetchMovieDetail(imdbID: id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let detail):
                    self?.updateUI(with: detail)
                case .failure(let error):
                    print("Error cargando detalle: \(error.localizedDescription)")
                }
            }
        }
    }

    func updateUI(with detail: MovieDetail) {

        titleLabel.text = detail.Title ?? "Sin título"
        yearLabel.text = detail.Year ?? "-"
        runtimeLabel.text = "Duración: \(detail.Runtime ?? "-")"
        directorLabel.text = "Director: \(detail.Director ?? "-")"
        genreLabel.text = "Género: \(detail.Genre ?? "-")"
        countryLabel.text = "País: \(detail.Country ?? "-")"
        sinopsisLabel.text = detail.Plot ?? "Sin sinopsis disponible"

        if detail.Poster != "N/A" {
            posterImageView.loadFrom(url: detail.Poster!)
        } else {
            posterImageView.image = UIImage(systemName: "photo")
        }
    }
}
