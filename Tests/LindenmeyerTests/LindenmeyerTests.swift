import XCTest
import class Foundation.Bundle
@testable import Lindenmeyer

final class LindenmeyerTests: XCTestCase {
    //unable to find samples for Cantor + Sierpinski, so just used what the current code outputs 
    //in order to maintain consistency in the future.
    func testRulePrettyPrint() throws {
      let rules = [
        (ProductionRule(predecessor: "A", successor: "AB"), #""A" -> "AB""#),
        (ProductionRule(predecessor: "B", successor: "A"), #""B" -> "A""#),
      ]
      for (input, expected) in rules {
        XCTAssertEqual(input.prettyPrint(), expected)
		  }
    }

    func testAlgaeIncremental() throws {
      //https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
      let rules = [
        ProductionRule(predecessor: "A", successor: "AB"),
        ProductionRule(predecessor: "B", successor: "A")
      ]
      let lSystem = LSystem(alphabet: ["A", "B"], axiom: "A", productionRules: rules)
      XCTAssertEqual(lSystem.produce(generationCount: 1), "AB")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABA")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABAAB")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABAABABA")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABAABABAABAAB")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABAABABAABAABABAABABA")
      XCTAssertEqual(lSystem.produce(generationCount: 1), "ABAABABAABAABABAABABAABAABABAABAAB")
    }

    func testAlgae() throws {
      //https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
      let rules = [
        ProductionRule(predecessor: "A", successor: "AB"),
        ProductionRule(predecessor: "B", successor: "A")
      ]
      let lSystem = LSystem(alphabet: ["A", "B"], axiom: "A", productionRules: rules)
      XCTAssertEqual(lSystem.produce(generationCount: 7), "ABAABABAABAABABAABABAABAABABAABAAB")
    }
    func testFractalTree() throws {
		//https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
		let rules = [
			ProductionRule(predecessor: "1", successor: "11"),
			ProductionRule(predecessor: "0", successor: "1[0]0")
		]
		let lSystem = LSystem(alphabet: ["1", "0", "[", "]"], axiom: "0", productionRules: rules)
		XCTAssertEqual(lSystem.produce(generationCount: 3), "1111[11[1[0]0]1[0]0]11[1[0]0]1[0]0")
	}
	func testCantorSet() throws {
		//https://en.wikipedia.org/wiki/L-system#Example_3:_Cantor_set
		let rules = [
			ProductionRule(predecessor: "A", successor: "ABA"),
			ProductionRule(predecessor: "B", successor: "BBB")
		]
		let lSystem = LSystem(alphabet: ["A", "B"], axiom: "A", productionRules: rules)
		XCTAssertEqual(lSystem.produce(generationCount: 3), "ABABBBABABBBBBBBBBABABBBABA")
	}
	func testKochCurve() throws {
		//https://en.wikipedia.org/wiki/L-system#Example_4:_Koch_curve
		let rules = [
			ProductionRule(predecessor: "F", successor: "F+F-F-F+F"),
		]
		let lSystem = LSystem(alphabet: ["F", "+", "-"], axiom: "F", productionRules: rules)
		XCTAssertEqual(lSystem.produce(generationCount: 2), "F+F-F-F+F+F+F-F-F+F-F+F-F-F+F-F+F-F-F+F+F+F-F-F+F")
	}
	func testSierpinskiTriangle() throws {
		//https://en.wikipedia.org/wiki/L-system#Example_5:_Sierpinski_triangle
		let rules = [
    ProductionRule(predecessor: "F", successor: "F-G+F+G-F"),
    ProductionRule(predecessor: "G", successor: "GG")
  ]
  let lSystem = LSystem(alphabet: ["F", "G", "+", "-"], axiom: "F-G-G", productionRules: rules)
		XCTAssertEqual(lSystem.produce(generationCount: 2), "F-G+F+G-F-GG+F-G+F+G-F+GG-F-G+F+G-F-GGGG-GGGG")
	}
    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
      ("testRulePrettyPrint", testRulePrettyPrint),
      ("testAlgaeIncremental", testAlgaeIncremental),
      ("testAlgae", testAlgae),
      ("testFractalTree", testFractalTree),
      ("testCantorSet", testCantorSet),
      ("testKochCurve", testKochCurve),
      ("testSierpinskiTriangle", testSierpinskiTriangle)
    ]
}
