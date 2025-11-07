//
//  ViewController.swift
//  ios101-project6-tumblr
//

//
//  ViewController.swift
//  ios101-project6-tumblr
//

import UIKit
import NukeExtensions

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var posts: [Post] = []

    private var selectedPost: Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Tumblr Feed"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        fetchPosts()
    }

    // MARK: - Fetch Tumblr posts
    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!

        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error fetching posts:", error.localizedDescription)
                return
            }

            guard let data = data else { return }
            if let responseDictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let response = responseDictionary["response"] as? [String: Any],
               let postsArray = response["posts"] as? [[String: Any]] {
                DispatchQueue.main.async {
                    self.posts = postsArray.compactMap { Post(dict: $0) }
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        let post = posts[indexPath.row]

        // ImageView (Tag = 101)
        if let iv = cell.contentView.viewWithTag(101) as? UIImageView,
           let url = post.photos.first?.originalSize.url {
            NukeExtensions.loadImage(with: url, into: iv)
        }

        // Label (Tag = 102)
        if let label = cell.contentView.viewWithTag(102) as? UILabel {
            label.text = post.summary
        }

        return cell
    }

    // MARK: - Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPost = posts[indexPath.row]
        performSegue(withIdentifier: "showDetailManual", sender: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let i = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: i, animated: true)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showDetailManual" else { return }

        // Get the destination DetailViewController
        let target: DetailViewController?
        if let vc = segue.destination as? DetailViewController {
            target = vc
        } else if let nav = segue.destination as? UINavigationController,
                  let vc = nav.topViewController as? DetailViewController {
            target = vc
        } else {
            print("❌ Destination not DetailViewController:", segue.destination)
            return
        }

        // Pass the selected post
        guard let post = selectedPost else {
            print("❌ selectedPost is nil in prepare(for:)")
            return
        }
        target!.post = post
        print("✅ Passed post to Detail")
    }
}
