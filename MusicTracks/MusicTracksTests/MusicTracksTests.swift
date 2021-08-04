//
//  MusicTracksTests.swift
//  MusicTracksTests
//
//  Created by Khatib Mahad H. on 8/3/21.
//

import XCTest
@testable import MusicTracks

class MusicTracksTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMusicItemDecoding() {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "SampleContents", withExtension: "json"),
            let data = try? Data(contentsOf: url) else {
                return
        }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = iTunesAPI.dateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        guard let musicItems = try? decoder.decode(iTunesResponseBody.self, from: data) else {
            return
        }
        
        let trackCount = musicItems.results.filter({$0.wrapperType == .track}).count
        XCTAssertEqual(trackCount, 49)
        
        let audiobookCount = musicItems.results.filter({$0.wrapperType == .audiobook}).count
        XCTAssertEqual(audiobookCount, 1)
        
        let firstItem = musicItems.results.first
        XCTAssertEqual(firstItem?.trackName, "Taylor Swift")
    }

}
