class ProductionRule {
    let predecessor: Character;
    let successor: String;
    init(predecessor: Character, successor: String ) {
        self.predecessor = predecessor
        self.successor = successor
    }
    func validate(alphabet: Set<Character>) -> Character? {
        for character in successor {
                if !alphabet.contains(character) {
                    return character
                }
            }
        return nil
    }
    func prettyPrint() -> String {
        "\"\(predecessor)\" -> \"\(successor)\""
    }
}

class LSystem {
    private let alphabet: Set<Character>;
    private let rules: Dictionary<Character, String?>;
    var axiom: String
    init(alphabet: [Character], axiom: String, productionRules: [ProductionRule]) {
        self.axiom = axiom
        self.alphabet = Set(alphabet)
        var tempRules : Dictionary<Character, String?> = Dictionary()
        for character in alphabet {
            tempRules[character] = Optional(Optional(nil))
        }
        for rule in productionRules {
            if let char = rule.validate(alphabet:self.alphabet) {
                fatalError("Rule: \"\(char)\" from \(rule.prettyPrint()) does not validate\nagainst the alphabet \(alphabet)")
            }
            if let currentRule = tempRules[rule.predecessor] {
                if let currentRuleExists = currentRule {
                    fatalError("Rule: \"\(rule.predecessor)\" -> \"\(currentRuleExists)\" already exists.\nCannot be overwritten by \(rule.prettyPrint())")
                } else {
                    tempRules[rule.predecessor] = rule.successor
                }
            } else {
                 fatalError("Character \"\(rule.predecessor)\" is not part of the alphabet.\n Rule: \(rule.prettyPrint()) cannot be inserted.")
            }
        }
        self.rules = tempRules
    }
    func nonTerminals() -> Set<Character> {
        var res: Set<Character> = Set()
        for (k, v) in self.rules {
            if v != nil {
                res.insert(k)
            }
        }
        return res
    }
    func terminals() -> Set<Character> {
        var res: Set<Character> = Set()
        for (k, v) in self.rules {
            if v == nil {
                res.insert(k)
            }
        }
        return res
    }
    func produce(generationCount: UInt) -> String {
        if generationCount == 0 {
            return self.axiom
        }
        var res = ""
        for character in self.axiom {
            if let replace = self.rules[character]! {
                res += replace
            } else {
                res += String(character)
            }
        }

        self.axiom=res
        return produce(generationCount: generationCount-1)
    }
}

