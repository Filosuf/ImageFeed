//
//  ImagesListViewController.swift
//  ImageFeed
//
//  Created by 1234 on 24.09.2022.
//

import UIKit

class ImagesListViewController: UIViewController {

    // MARK: - Properties
    @IBOutlet private var tableView: UITableView!

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Methods
    func configCell(for cell: ImagesListCell) { }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

// MARK: - UITableViewDelegate
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) // 1

        guard let imageListCell = cell as? ImagesListCell else { // 2
            return UITableViewCell()
        }
         
        configCell(for: imageListCell) // 3
        return imageListCell // 4
    }


}
