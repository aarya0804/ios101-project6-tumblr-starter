//
//  DetailViewController.swift
//  ios101-project6-tumblr
//
//  Created by Aarya Awasthy on 11/6/25.
//



import UIKit
import NukeExtensions

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var post: Post!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Post"
        navigationController?.navigationBar.prefersLargeTitles = false

        if tableView == nil {
            fatalError("❌ DetailViewController.tableView outlet is NOT connected.")
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
        tableView.separatorStyle = .none

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)

        guard let post = post else {
            print("❌ post is nil in cellForRowAt — check prepare(for:)")
            return cell
        }

        // Image (Tag = 101)
        if let iv = cell.contentView.viewWithTag(101) as? UIImageView,
           let url = post.photos.first?.originalSize.url {
            NukeExtensions.loadImage(with: url, into: iv)
        }

        // Optional Label (Tag = 102)
        if let label = cell.contentView.viewWithTag(102) as? UILabel {
            label.text = post.caption.trimHTMLTags()
            label.numberOfLines = 0
        }

        cell.selectionStyle = .none
        return cell
    }
}
