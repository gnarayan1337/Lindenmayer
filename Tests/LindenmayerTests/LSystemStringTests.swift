import XCTest
@testable import Lindenmayer

final class LSystemStringTests: XCTestCase {
    typealias Rules = [ProductionRule<Character, String>]
    func SimpleL(_ alphabet: String, _ inputRules: [Character:String], _ axiom: String) -> (UInt) -> String {
        var rules: Rules = []
        for rule in inputRules {
            rules.append(.init(predecessor: rule.key, successor: rule.value))
        }
        let sys = try! LSystem(alphabet: alphabet, axiom: axiom, productionRules: rules)
        return {(generations: UInt) -> String in
            sys.produce(generationCount: generations)
        }
    }
    func testIncrementalAlgae() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
        let sys = SimpleL("AB", ["A" : "AB", "B" : "A"], "A")
        XCTAssertEqual(sys(1), "AB")
        XCTAssertEqual(sys(2), "ABA")
        XCTAssertEqual(sys(3), "ABAAB")
        XCTAssertEqual(sys(4), "ABAABABA")
        XCTAssertEqual(sys(5), "ABAABABAABAAB")
        XCTAssertEqual(sys(6), "ABAABABAABAABABAABABA")
        XCTAssertEqual(sys(7), "ABAABABAABAABABAABABAABAABABAABAAB")
    }
    func testAlgae() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
        let sys = SimpleL("AB", ["A": "AB", "B":"A"], "A")
        XCTAssertEqual(sys(7), "ABAABABAABAABABAABABAABAABABAABAAB")
    }
    
    func testFractalTree() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_2:_Fractal_(binary)_tree
        let sys = SimpleL("110[]", ["1":"11","0":"1[0]0"], "0")
        XCTAssertEqual(sys(3), "1111[11[1[0]0]1[0]0]11[1[0]0]1[0]0")
    }
    
    func testCantorSet() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_3:_Cantor_set
        let sys = SimpleL("AB", ["A":"ABA","B":"BBB"], "A")
        XCTAssertEqual(sys(3), "ABABBBABABBBBBBBBBABABBBABA")
    }

    func testKochCurve() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_4:_Koch_curve
        let sys = SimpleL("F+-", ["F":"F+F-F-F+F"], "F")
        XCTAssertEqual(sys(2), "F+F-F-F+F+F+F-F-F+F-F+F-F-F+F-F+F-F-F+F+F+F-F-F+F")
    }
    func testSierpinskiTriange() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_5:_Sierpinski_triangle
        let sys = SimpleL("F+-G", ["F": "F-G+F+G-F", "G" : "GG"], "F-G-G")
        XCTAssertEqual(sys(2), "F-G+F+G-F-GG+F-G+F+G-F+GG-F-G+F+G-F-GGGG-GGGG")
    }
    
}

