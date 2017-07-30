import Foundation

extension Sequence {
    public func failingFlatMap<T>(_ transform: (Self.Iterator.Element) throws -> T?) rethrows -> [T]? {
        var result: [T] = []
        for element in self {
            guard let transformed = try transform(element) else { return nil }
            result.append(transformed)
        }
        return result
    }
    
    /// Returns a sequence that repeatedly cycles through the elements of `self`.
    public func cycled() -> AnySequence<Iterator.Element> {
        return AnySequence { _ -> AnyIterator<Iterator.Element> in
            var iterator = self.makeIterator()
            return AnyIterator {
                if let next = iterator.next() {
                    return next
                } else {
                    iterator = self.makeIterator()
                    return iterator.next()
                }
            }
        }
    }
}
