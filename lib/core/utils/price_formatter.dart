/// Extension on double for consistent price formatting
extension PriceFormatter on double {
  /// Formats the price to always show exactly 2 decimal places
  /// Examples:
  /// - 9.0 → "$9.00"
  /// - 12.5 → "$12.50"
  /// - 99.99 → "$99.99"
  String toPriceString() {
    return '\$${toStringAsFixed(2)}';
  }
}

/// Extension on num for consistent price formatting
extension NumPriceFormatter on num {
  /// Formats the price to always show exactly 2 decimal places
  /// Examples:
  /// - 9 → "$9.00"
  /// - 12.5 → "$12.50"
  /// - 99.99 → "$99.99"
  String toPriceString() {
    return '\$${toStringAsFixed(2)}';
  }
}
