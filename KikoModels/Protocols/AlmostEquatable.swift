infix operator ≈≈ : ComparisonPrecedence

public protocol AlmostEquatable {
    static func ≈≈(lhs: Self, rhs: Self) -> Bool
}
