//
//  Extension.swift
//  WidgetsExtension
//
//  Created by 近松 和矢 on 2022/02/25.
//

import Foundation

extension Date {
    static func -(lhs: Date, rhs: Date) -> TimeInterval{
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}
