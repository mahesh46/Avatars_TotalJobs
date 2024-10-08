
import UIKit

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var loginLabel: UILabel!
    @IBOutlet weak private var githubLabel: UILabel!
    
        override func prepareForReuse() {
            super.prepareForReuse()
            
            imageView.image = nil
        }
    
    var login: String? {
        get {
            loginLabel.text
        }
        set {
            loginLabel.text = newValue
        }
    }
    
    var github: String? {
        get {
            githubLabel.text
        }
        set {
            githubLabel.text = "GitHub: \(newValue ?? "N/A")"
        }
    }
    
    var image: UIImage? {
        get {
            imageView.image
        }
        set {
            imageView.image = newValue
        }
    }
    
    var githubUser: GitUser? {
        didSet {
            
            login = githubUser?.login
            github = githubUser?.html_url
        }
    }
    
    var imageData: Data? {
        didSet {
            self.imageView.image = UIImage(data: imageData!)
        }
    }
    
    var activity : Bool? {
        didSet {
            if activity == false {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            } else {
                DispatchQueue.main.async {
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
    
    var networkService: NetworkService?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.2)
        contentView.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        accessibility()
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        imageView.clipsToBounds = true
    }
    
    func accessibility() {
        imageView.accessibilityIdentifier = "cellImage"
        loginLabel.accessibilityIdentifier = "cellLogInLabel"
        githubLabel.accessibilityIdentifier = "cellGithubLabel"
    }
    
    func loadImage(from url: URL) async {
           Task.init {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                } catch {
                    print("Error loading image: \(error)")
                }
            }
       
        }
}
