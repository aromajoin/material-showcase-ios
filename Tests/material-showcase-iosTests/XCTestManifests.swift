import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(material_showcase_iosTests.allTests),
    ]
}
#endif
