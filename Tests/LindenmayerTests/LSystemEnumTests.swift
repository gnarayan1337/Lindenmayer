import XCTest
@testable import Lindenmayer

final class LSystemEnumTests: XCTestCase {
    fileprivate typealias Rule = ProductionRule<State, [State]>
    fileprivate typealias Sys = LSystem<State, [State]>
    func testIncrementalAlgae() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
        let rules: [Rule] = [
            .init(.A, states("AB")),
            .init(.B, states("A")),
        ]
        let sys: Sys = try! LSystem(alphabet: [.A, .B], axiom: [.A], productionRules: rules)
        XCTAssertEqual(
            sys.produce(),
            states("AB")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABA")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABAAB")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABAABABA")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABAABABAABAAB")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABAABABAABAABABAABABA")
        )
        XCTAssertEqual(
            sys.produce(),
            states("ABAABABAABAABABAABABAABAABABAABAAB")
        )
    }
    func testAlgae() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
        let rules: [Rule] = [
            .init(.A, [.A, .B]),
            .init(.B, [.A])
        ]
        let sys: Sys = try! LSystem(alphabet: [.A, .B], axiom: [.A], productionRules: rules)
        XCTAssertEqual(
            sys.produce(generationCount: 7),
            states("ABAABABAABAABABAABABAABAABABAABAAB")
        )
    }
    func testFractalTree() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_1:_Algae
        let rules: [Rule] = [
            .init(.O, [.O, .O]),
            .init(.Z, states("1[0]0"))
        ]
        let sys: Sys = try! LSystem(alphabet: states("110[]"), axiom: [.Z], productionRules: rules)
        let expected = sys.produce(generationCount: 3)
        let actual = states("1111[11[1[0]0]1[0]0]11[1[0]0]1[0]0")
        XCTAssertEqual(expected, actual)
    }
    func testCantorSet() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_3:_Cantor_set
        let rules: [Rule] = [
            .init(.A, states("ABA")),
            .init(.B, states("BBB"))
        ]
        let sys: Sys = try! LSystem(alphabet: [.A,.B], axiom: [.A], productionRules: rules)
        let expected = sys.produce(generationCount: 3)
        let actual = states("ABABBBABABBBBBBBBBABABBBABA")
        XCTAssertEqual(expected, actual)
    }
    func testKochCurve() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_4:_Koch_curve
        let rules: [Rule] = [
            .init(.F, states("F+F-F-F+F")),
        ]
        let sys: Sys = try! LSystem(alphabet: [.F,.P,.M], axiom: [.F], productionRules: rules)
        let expected = sys.produce(generationCount: 2)
        let actual = states("F+F-F-F+F+F+F-F-F+F-F+F-F-F+F-F+F-F-F+F+F+F-F-F+F")
        XCTAssertEqual(expected, actual)
    }
    func testSierpinskiTriangle() {
        //src:https://en.wikipedia.org/wiki/L-system#Example_5:_Sierpinski_triangle
        let rules: [Rule] = [
            .init(.F, states("F-G+F+G-F")),
            .init(.G, states("GG"))
        ]
        let sys: Sys = try! LSystem(alphabet: [.F,.P,.M, .G], axiom: states("F-G-G"), productionRules: rules)
        let expected = sys.produce(generationCount: 2)
        let actual = states("F-G+F+G-F-GG+F-G+F+G-F+GG-F-G+F+G-F-GGGG-GGGG")
        XCTAssertEqual(expected, actual)
    }    
}

fileprivate enum State: Character {
    case A = "A"
    case B = "B"
    case P = "+"
    case M = "-"
    case F = "F"
    case G = "G"
    case O = "1"
    case Z = "0"
    case L = "["
    case R = "]"
}
fileprivate func states(_ v: String) -> [State] {
    v.map{
        State.init(rawValue: $0)!
    }
}
