//
//  TweetTableViewCell.swift
//  GCStream
//
//  Created by Steve Spigarelli on 8/31/17.
//  Copyright © 2017 Steve Spigarelli. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell {

    @IBOutlet var tweetProfileImageView: UIImageView?
    @IBOutlet var tweetCreatedLabel: UILabel?
    @IBOutlet var tweetUserLabel: UILabel?
    @IBOutlet var tweetTextLabel: UILabel?

    var tweet: Twitter.Tweet? { didSet { updateUI() } }

    private func updateUI() {
        tweetTextLabel?.text = tweet?.text
        tweetUserLabel?.text = tweet?.user.description

        if let profileImageURL = tweet?.user.profileImageURL {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async { [weak self] in
                        self?.tweetProfileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            tweetProfileImageView?.image = nil
        }

        if let created = tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) >  24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.dateStyle = .long
            }
            tweetCreatedLabel?.text = formatter.string(from: created)
        } else {
            tweetCreatedLabel?.text = nil
        }
    }
}
