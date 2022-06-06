//
//  userModel.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/20.
//

import Foundation

public class userModel: Codable, Identifiable{
    public var userID: String? = ""
    public var userPW: String? = ""
    public var userNAME: String? = ""
    public var userTEL: String? = ""
}
