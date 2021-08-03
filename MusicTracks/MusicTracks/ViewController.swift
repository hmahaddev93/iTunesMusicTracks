//
//  ViewController.swift
//  MusicTracks
//
//  Created by Khatib Mahad H. on 8/3/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iTunesService().search(query: "taylor swift") { result in
            switch result {
            
            case .success(let tracks):
                print(tracks)
            case .failure(let error):
                print(error)
            }
        }
    }

}

