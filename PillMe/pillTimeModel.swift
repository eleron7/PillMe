//
//  userModel.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/20.
//

import Foundation

public class pillTimeModel: Codable, Identifiable{
    public var moduleNum: String? = ""
    public var PillName: String? = ""
    public var PillMaster: String? = ""
    public var EatTime: String? = ""
}
