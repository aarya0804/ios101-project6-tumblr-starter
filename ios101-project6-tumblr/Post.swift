//
//  Post.swift
//  ios101-project6-tumblr
//


import Foundation

struct Post {
    let summary: String
    let caption: String
    let photos: [Photo]

    init?(dict: [String: Any]) {
        self.summary = dict["summary"] as? String ?? ""
        self.caption = dict["caption"] as? String ?? ""

        // Extract photos
        if let photosArray = dict["photos"] as? [[String: Any]] {
            self.photos = photosArray.compactMap { Photo(dict: $0) }
        } else {
            self.photos = []
        }
    }
}

struct Photo {
    let originalSize: OriginalSize

    init?(dict: [String: Any]) {
        if let originalDict = dict["original_size"] as? [String: Any],
           let urlString = originalDict["url"] as? String,
           let url = URL(string: urlString) {
            self.originalSize = OriginalSize(url: url)
        } else {
            return nil
        }
    }
}

struct OriginalSize {
    let url: URL
}
