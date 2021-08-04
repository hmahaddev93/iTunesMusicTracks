//
//
//  Created by Khatib Mahad H. on 7/18/21.
//

import UIKit

final class TracksViewController: UIViewController {

    private let viewModel: TracksViewModel
    private let alertPresenter: AlertPresenter_Proto = AlertPresenter()

    lazy var tracksView = TracksView()

    init(viewModel: TracksViewModel = TracksViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = tracksView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tracksView.tableView.dataSource = self
        tracksView.tableView.delegate = self
        tracksView.searchBar.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapBg(sender:)))
        tracksView.addGestureRecognizer(tapGesture)
    }
    
    private func searchMusicTrackByArtist(query: String) {
        showSpinner()
        viewModel.fetchTracks(query: query) {[unowned self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.update()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.display(error: error)
                }
            }
            
        }
    }
    
    private func update() {
        tracksView.tableView.reloadData()
    }
    
    private func display(error: Error) {
        alertPresenter.present(from: self,
                               title: "Unexpected Error",
                               message: "\(error.localizedDescription)",
                               dismissButtonTitle: "OK")
    }
    
    private func showSpinner() {
        tracksView.activityIndicatorView.startAnimating()
    }
    
    private func hideSpinner() {
        self.tracksView.activityIndicatorView.stopAnimating()
    }
    
    private func dismissKeyboard() {
        self.tracksView.searchBar.resignFirstResponder()
    }
    
    @objc func onTapBg(sender: Any) {
        dismissKeyboard()
    }
}

extension TracksViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text, !query.replacingOccurrences(of: " ", with: "").isEmpty {
            searchMusicTrackByArtist(query: query)
        }
        else {
            viewModel.tracks.removeAll()
            self.update()
        }
        searchBar.resignFirstResponder()
    }
}

extension TracksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let trackCell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell {
            let musicTrack = viewModel.tracks[indexPath.row]
            trackCell.track = musicTrack
            return trackCell
        }
        return UITableViewCell()
    }
}

extension TracksViewController: UITableViewDelegate {
}


