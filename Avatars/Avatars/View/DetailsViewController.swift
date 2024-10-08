
import UIKit

class DetailsViewController: UIViewController {
    
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var usernameLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    @IBOutlet weak private var detailsStackView: UIStackView!
    @IBOutlet weak var detailviewActivityInd: UIActivityIndicatorView!
    
    var github: GitUser!
    var networkService: NetworkService!
    var image: UIImage!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            setupAccessibilityIdentifiers()
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        detailviewActivityInd.isHidden = true
        loadDetails()
    }
    
    func setupAccessibilityIdentifiers() {
        imageView.accessibilityIdentifier = "userImage"
        usernameLabel.accessibilityIdentifier = "userLabel"
        githubLabel.accessibilityIdentifier = "githubGithubLabel"
    }
    
    func loadDetails() {
        self.imageView.image = self.image
        
        usernameLabel.text = github.login
        githubLabel.text = "GitHub:\n\(github.html_url)"
        detailviewActivityInd.isHidden = false
        detailviewActivityInd.startAnimating()
        var detailLabels = [UILabel]()
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkService.get(url: github.followers_url, resultType: [GitUser].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let followers):
                    detailLabels.append(self.makeLabel(text: "Followers: \(followers.count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Followers: N/A"))
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: github.following_url, resultType: [GitUser].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let followers):
                    detailLabels.append(self.makeLabel(text: "Following: \(followers.count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Following: N/A"))
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: github.repos_url, resultType: [Repo].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repositories):
                    detailLabels.append(self.makeLabel(text: "Repositories count: \(repositories.count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Repositories count: N/A"))
                }
                dispatchGroup.leave() //was missing
            }
        }
        
        dispatchGroup.enter()
        networkService.get(url: github.gists_url, resultType: [Gist].self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let gists):
                    detailLabels.append(self.makeLabel(text: "Gists count: \(gists.count)"))
                case .failure:
                    detailLabels.append(self.makeLabel(text: "Gists count: N/A"))
                }
            }
            dispatchGroup.leave()
        }
        // dispatchGroup.wait()  --ToDo: remove
        //added noftiy
        dispatchGroup.notify(queue: .main) { [self] in
            // All network requests have completed
            detailviewActivityInd.isHidden = true
            detailviewActivityInd.stopAnimating()
            detailLabels.forEach { label in
                detailsStackView.addArrangedSubview(label)
            }
        }
    }
    
    func makeLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        return label
    }
}
