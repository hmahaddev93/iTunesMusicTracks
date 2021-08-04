//
//
//  Created by Khatib Mahad H. on 7/19/21.
//

import UIKit

final class TrackCell: UITableViewCell {

    var track: MusicItem? {
        didSet {
            self.artistLabel.text = track?.artistName
            self.trackLabel.text = track?.trackName
            self.genreLabel.text = track?.primaryGenreName
            self.releaseDateLabel.text = track?.releaseDate.formatted
            
            if let price = track?.trackPrice {
                self.trackPriceLabel.text = String(format: "$%.02f", price)
            }
            else {
                self.trackPriceLabel.text = ""
            }
            
            guard let artworkUrlString:String = track?.artworkUrl100 else {
                return
            }
            self.artworkImageView.loadThumbnail(urlSting: artworkUrlString)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let artworkImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        return imageView
    }()
    let artistLabel = MTLabel(style: .caption1)
    let trackLabel = MTLabel(style: .caption1)
    let trackPriceLabel = MTLabel(style: .caption1)
    let releaseDateLabel = MTLabel(style: .caption1)
    let genreLabel = MTLabel(style: .caption1)
    
    private lazy var artworkStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artworkImageView, UIView()])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var trackStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [trackLabel, UIView(), trackPriceLabel])
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artistLabel,
                                                       trackStackView,
                                                       releaseDateLabel,
                                                       genreLabel])
        stackView.axis = .vertical
        stackView.spacing = 12.0
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [artworkStackView, labelsStackView])
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func commonInit() {
        backgroundColor = .white
        safelyAddSubview(stackView)
        stackView.marginToSuperviewSafeArea(top: 12, bottom: 12, leading: 16, trailing: 16)
    }
}
