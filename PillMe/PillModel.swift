//
//  pillModel.swift
//  capstoneDesignProject_pillme
//
//  Created by 승헌 on 2022/05/21.
//

import Foundation

public class pillModel: Codable, Identifiable{
    public var ModuleNum: String? = ""
    public var PillMaster: String? = ""
    public var PillName: String? = ""
    public var PillLength: String? = ""
    public var PillAmount: String? = ""
    public var PillTime: String? = ""
    public var PillEat: String? = ""
}
