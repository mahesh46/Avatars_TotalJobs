// MockDownLoadAvitar.swift
//
// Copyright © 2023 Stepstone. All rights reserved.

import XCTest
@testable import Avatars


class MockAvatarImageDataError: LoadAvitarProtocol {
    func downloadAvatar(avatarID: String, size: Int) async throws -> UIImage {
        let url = URL(string: "https://www.google.co.uk")!
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidImageData
        }
        
        return image
    }
}

class MockAvatarNetworkError: LoadAvitarProtocol {
    func downloadAvatar(avatarID: String, size: Int) async throws -> UIImage {
        guard let _ = URL(string: "https://@") else {
            
            throw NetworkError.invalidURL
        }
        return UIImage()
    }
}


