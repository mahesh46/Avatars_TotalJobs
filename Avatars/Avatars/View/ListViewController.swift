
import UIKit

class ListViewController: UICollectionViewController {
 //   private let cache = NSCache<NSString, NSData>()
    private let networkService = NetworkService()
    
    private var githubUsers = [GitUser]()
    var listViewModel: ListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configure() {
        self.listViewModel = ListViewModel()
        
        Task {
            if let users = await listViewModel.getGitUser() {
                githubUsers = users
                self.collectionView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return githubUsers.count
    }
    
    fileprivate func loadImageForCell(_ indexPath: IndexPath, _ cell: AvatarCell) {
               
        if let imageUrl = URL( string: githubUsers[indexPath.row].avatar_url ) {
            cell.activity = true
            Task {
                await cell.loadImage(from: imageUrl)
                cell.activity = false
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)  -> UICollectionViewCell {
        let identifier = String(describing: AvatarCell.self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! AvatarCell
        cell.networkService = networkService
        cell.githubUser = githubUsers[indexPath.row]
        cell.activity = true
        loadImageForCell(indexPath, cell)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? AvatarCell, let githubUser = cell.githubUser else { return }
        guard let profileViewController = segue.destination as? DetailsViewController else { return }
        profileViewController.image = cell.image
        profileViewController.networkService = networkService
        profileViewController.github = githubUser
    }
}

extension ListViewController: UICollectionViewDelegateFlowLayout {
    private var insets: UIEdgeInsets { UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0) }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width - 2 * insets.left, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
}
