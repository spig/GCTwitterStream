//
//  TweetTableViewController.swift
//  GCStream
//
//  Created by Steve Spigarelli on 8/30/17.
//  Copyright © 2017 Steve Spigarelli. All rights reserved.
//

import UIKit
import Twitter
//import TwitterKit

class TweetTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet var searchBar: UISearchBar? {
        didSet {
            searchBar?.delegate = self
        }
    }

//    private var tweets2 = [Array<TWTRTweet>]()
    private var tweets = [[]]//[Array<Twitter.Tweet>]()

    var searchText: String? {
        didSet {
            searchBar?.text = searchText
            searchBar?.resignFirstResponder()
            tweets.removeAll()
            tableView.reloadData()
            searchForTweets()
            title = searchText
        }
    }

    private func twitterRequest() -> Twitter.Request? {
        guard let searchText = searchText, !searchText.isEmpty else { return nil }

        return Twitter.Request(search: searchText, count: 100)
    }

    private var lastTwitterRequest: Twitter.Request?

    private func searchForTweets() {
        if let request = twitterRequest() {
            lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.tweets.insert(newTweets, at: 0)
                        self?.tableView?.insertSections([0], with: .fade)
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let key = ""
//        let secret = ""
//        Twitter.sharedInstance().start(withConsumerKey: key, consumerSecret: secret)
//
//        let client = TWTRAPIClient()
//        let searchEndpoint = "https://api.twitter.com/1.1/search/tweets.json"
//        let params = ["q": "#ldsconf"]
//        var clientError: NSError?
//        let request = client.urlRequest(withMethod: "GET", url: searchEndpoint, parameters: params, error: &clientError)
//
//        client.sendTwitterRequest(request) { response, data, connectionError -> Void in
//            if connectionError != nil {
//                print("Error: \(connectionError)")
//            }
//
//            do {
//                let json = try JSONSerialization.jsonObject(with: data!, options: [])
//                print("json: \(json)")
//            } catch let jsonError as NSError {
//                print("json error: \(jsonError.localizedDescription)")
//            }
//        }

        searchText = "#ldsconf"

        tableView?.estimatedRowHeight = tableView?.rowHeight ?? 0
        tableView?.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)

        let tweet = tweets[indexPath.section][indexPath.row]

        if let cell = cell as? TweetTableViewCell {
            cell.tweet = tweet
        }

        return cell
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("user did end editing searchbar text")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("text did change... \(searchText)")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
