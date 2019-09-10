//
//  DebugHelper.swift
//  1-Planes
//
//  Created by Mehmet Tarhan on 19.05.2019.
//  Copyright © 2019 Mehmet Tarhan. All rights reserved.
//

import Foundation

func currentDateString() -> String {
    let df = DateFormatter()
    df.dateFormat = "dd-MM HH:mm:ss.SSSS"
    return df.string(from: Date())
}

func dlog(
    _ tag: AnyObject,
    _ items: Any...) {
    #if DEBUG
    var list : [Any] = []
    let logInfo = currentDateString() + " " + String(describing: tag)
    list.append(logInfo)
    list.append(contentsOf: items)
    print(list, separator: " ", terminator: "\n")
    #endif
}
