//
//  File.swift
//  iHorizon
//
//  Created by ahmed.fouadgomaa on 5/16/18.
//  Copyright © 2018 ahmedfouad. All rights reserved.
//

import Foundation
struct GitHubRepos {
    var name:String
    var description:String
    var avatar_url: String
    var forks_count:String
    var resuestInfoParams: NSArray{
        
        return [name, description, avatar_url, forks_count]
        
    }
}
