//
//
//  Created by Khatib Mahad H. on 7/19/21.
//

import Foundation

class TracksViewModel {
    // MARK: - Initialization
    init(model: [MusicItem]? = nil) {
        if let inputModel = model {
            tracks = inputModel
        }
    }
    var tracks = [MusicItem]()
}

extension TracksViewModel {
    func fetchTracks(query: String, completion: @escaping (Result<[MusicItem], Error>) -> Void) {
        iTunesService().search(query: query) { [unowned self] result in
            switch result {
            case .success(let tracks):
                self.tracks = tracks
                completion(.success(tracks))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
