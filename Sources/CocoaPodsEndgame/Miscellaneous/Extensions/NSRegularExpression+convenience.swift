import Foundation

extension NSRegularExpression {
    func firstMatch(in text: String) -> String? {
        let result = self.matches(in: text, range: NSRange(text.startIndex..., in: text))
        return result.first.map {
            String(text[Range($0.range, in: text)!])
        }
    }

    func matches(in text: String) -> [String] {
        let result = matches(in: text, range: NSRange(text.startIndex..., in: text))
        return result.map {
            String(text[Range($0.range, in: text)!])
        }
    }

    func groupMatches(in text: String) -> [[String]] {
        let result = matches(in: text, range: NSRange(text.startIndex..., in: text))
        return result.map { match in
            return (1 ..< match.numberOfRanges).map {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return ""
                }
                return String(text[range])
            }
        }
    }
}
