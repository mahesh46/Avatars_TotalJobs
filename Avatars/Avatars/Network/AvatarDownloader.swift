
import UIKit
import Combine

class AvatarDownloader  : LoadAvitarProtocol {
    private enum Constants {
        static let endpoint = "https://i.pravatar.cc"
    }
    
    //    func downloadAvatar(avatarID: String, size: Int, completion: @escaping (Result<UIImage, Error>) -> Void) {
    //        var componenets = URLComponents(string: Constants.endpoint + "/" + "\(size)")
    //        componenets?.queryItems = [
    //            URLQueryItem(name: "img", value: avatarID)
    //        ]
    //        guard let imageUrl = componenets?.url else { return }
    //
    //        let request = URLRequest(url: imageUrl)
    //        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
    //            if let error = error as NSError? {
    //                completion(.failure(error))
    //            } else if let data, let image = UIImage(data: data) {
    //                completion(.success(image))
    //            }
    //        }
    //        dataTask.resume()
    //    }
    
    //updated function using combine
    //    func downloadAvatar(avatarID: String, size: Int) -> AnyPublisher<UIImage, Error> {
    //        var components = URLComponents(string: Constants.endpoint + "/" + "\(size)")
    //        components?.queryItems = [
    //            URLQueryItem(name: "img", value: avatarID)
    //        ]
    //
    //        guard let imageUrl = components?.url else {
    //            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
    //        }
    //
    //        let request = URLRequest(url: imageUrl)
    //
    //        return URLSession.shared.dataTaskPublisher(for: request)
    //            .tryMap { (data, response) -> UIImage in
    //                guard let image = UIImage(data: data) else {
    //                    throw NetworkError.invalidImageData
    //                }
    //                return image
    //            }
    //            .mapError { error -> Error in
    //                if let error = error as? URLError {
    //                    return NetworkError.urlError
    //                } else {
    //                    return error
    //                }
    //            }
    //            .eraseToAnyPublisher()
    //    }
    
    
    func downloadAvatar(avatarID: String, size: Int) async throws -> UIImage {
        var components = URLComponents(string: Constants.endpoint + "/" + "\(size)")
        components?.queryItems = [
            URLQueryItem(name: "img", value: avatarID)
        ]
        
        guard let imageUrl = components?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: imageUrl)
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidImageData
        }
        
        return image
    }
}


protocol LoadAvitarProtocol {
    func downloadAvatar(avatarID: String, size: Int) async throws -> UIImage
}
