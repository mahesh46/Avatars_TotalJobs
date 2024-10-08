// ListViewModel.swift
//
// Copyright © 2023 Stepstone. All rights reserved.

import Foundation

class ListViewModel {
    
    var gitUsers: [GitUser]?
    
    func getGitUser() async  -> [GitUser]? {
        do {
            let ArrayUser: [GitUser] = try await NetworkService.shared.get(url: .githubUsersEndpoint, resultType: [GitUser].self)
            self.gitUsers = ArrayUser
            return ArrayUser
        } catch  {
            print(error.localizedDescription)
            return nil
        }
    }
}
