class LSystem<T: Hashable & Equatable, U: Collection & Equatable & Take>
    where U.Element == T, U.T == T
{
    private let rules: [T : U];
    private var validator: (T) -> Bool = { (_ : T) -> Bool in true };
    private let axiom : U;
    private var state : U;
    private let alphabet: Set<T>?;
    init(alphabet: U? = nil, validator: Optional<(T) -> Bool> = nil, axiom: U, productionRules: [ProductionRule<T,U>]){
        self.alphabet = LSystem.initializeAlphabet(alphabet)
        self.axiom = axiom
        self.state = axiom
        self.rules = LSystem.initializeRules(productionRules)
        if let v = validator {
            self.validator = v
        } else if alphabet != nil  {
            self.validator = { self.alphabet!.contains($0) }
        }
    }
    func produce(generationCount: UInt = 1) -> U {
        if generationCount == 0 {
            return self.state
        }
        var res: [T] = []
        for point in self.state {
            res += self.rules[point] ?? U.take([point])
            
        }
        self.state = U.take(res)
        return produce(generationCount: generationCount-1)
    }
    private static func initializeAlphabet(_ alphabet: U?) -> Set<T>? {
        if let alphabet = alphabet {
            return Set(alphabet)
        } else {
            return nil
        }
    }
    private static func initializeRules(_ productionRules: [ProductionRule<T, U>]) -> Dictionary<T, U> {
        var rules : Dictionary<T, U> = Dictionary()
        for rule in productionRules {
            rules[rule.predecessor] = rule.successor
        }
        return rules
    }
}

