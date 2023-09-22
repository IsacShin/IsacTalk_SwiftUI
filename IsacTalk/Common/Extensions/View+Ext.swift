//
//  View+Ext.swift
//  IsacTalk
//
//  Created by 신이삭 on 2023/09/18.
//

import SwiftUI

public extension View {
    /// Sets the Dynamic Type size within the view to the given value.
    /// (Polyfill for previous versions)
    ///
    /// - SeeAlso:
    ///   - [dynamicTypeSize(_:)](https://developer.apple.com/documentation/swiftui/view/dynamictypesize%28_%3A%29-1m2tf)
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    func sizeCategory(_ size: ContentSizeCategory) -> some View {
        environment(\.sizeCategory, size)
    }
    
    /// Limits the Dynamic Type size within the view to the given range.
    /// (Polyfill for previous versions)
    ///
    /// - SeeAlso:
    ///   - [dynamicTypeSize(_:)](https://developer.apple.com/documentation/swiftui/view/dynamictypesize%28_%3A%29-26aj0)
    @available(iOS, introduced: 13.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(macOS, introduced: 10.15, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(tvOS, introduced: 13.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(watchOS, introduced: 6.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    @available(visionOS, introduced: 1.0, deprecated: 100000.0, renamed: "dynamicTypeSize(_:)")
    func sizeCategory<T: RangeExpression>(_ range: T) -> some View where T.Bound == ContentSizeCategory {
        modifier(SizeCategoryModifier(range: range))
    }
}

private struct SizeCategoryModifier: ViewModifier {
    @Environment(\.sizeCategory) private var sizeCategory
    
    private let range: ClosedRange<ContentSizeCategory>
    
    init<T: RangeExpression>(range: T) where T.Bound == ContentSizeCategory {
        self.range = range as? ClosedRange ?? {
            // Convert the range to ClosedRange
            let allCases = ContentSizeCategory.allCases.sorted()
            let lowerBound = allCases.first(where: range.contains(_:)) ?? allCases.first!
            let upperBound = allCases.last(where: range.contains(_:)) ?? allCases.last!
            return lowerBound...upperBound
        }()
    }
    
    func body(content: Content) -> some View {
        content
            .environment(\.sizeCategory, min(max(range.lowerBound, sizeCategory), range.upperBound))
    }
}

// Comparison functions are implemented by default in iOS 14, macOS 11, tvOS 14 and watchOS 7 or later.
// If you’re targeting later versions, you only need to make `ContentSizeCategory` conform to `Comparable`:
extension ContentSizeCategory: Comparable {}

// Or if not, you’ll also need the following functions:
/* public extension ContentSizeCategory {
 private var rawValue: UInt8 { unsafeBitCast(self, to: UInt8.self) }
 
 static func < (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
 lhs.rawValue < rhs.rawValue
 }
 
 static func > (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
 lhs.rawValue > rhs.rawValue
 }
 
 static func <= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
 lhs.rawValue <= rhs.rawValue
 }
 
 static func >= (lhs: ContentSizeCategory, rhs: ContentSizeCategory) -> Bool {
 lhs.rawValue >= rhs.rawValue
 }
 } */

@available(iOS 13.0, *)
extension View {
    public func endEditing(_ force: Bool) {
        UIApplication.shared.windows.forEach { $0.endEditing(force)}
    }
}
