class LSystem<T: Hashable & Equatable, U: Collection & Equatable & Take>
    where U.Element == T, U.T == T
{
    private let rules: [T : U];
    public let axiom : U;
     public var terminals: Set<T> {
        alphabet.filter { rules[$0] == nil }
    }
    public var nonTerminals: Set<T> {
        alphabet.filter { rules[$0] != nil }
    }
    public let alphabet: Set<T>;
    init<V: Collection>(alphabet: V, validator: Optional<(T) -> Bool> = nil, axiom: U, productionRules: [ProductionRule<T,U>]) throws where V.Element == T{
        self.alphabet = Set(alphabet)
        self.axiom = axiom
        do {
            self.rules = try LSystem.initializeRules(productionRules, self.alphabet)
        } catch {
            throw error
        }
        
    }
     init<V: Collection>(alphabet: V, validator: Optional<(T) -> Bool> = nil, axiom: U, productionRules: [T:U]) throws where V.Element == T {
        self.alphabet = Set(alphabet)
        self.axiom = axiom
        do {
            self.rules = try LSystem.initializeDictRules(productionRules, self.alphabet)
        } catch {
            throw error
        }
    }
    func produce(generationCount: UInt = 0) -> U {
        let res: U
        if generationCount == 0 {
            res = axiom
        } else {
            var wres: [T] = []
            let state = produce(generationCount: generationCount-1)
            for point in state {
                wres += self.rules[point] ?? U.take([point])

            }
            res = U.take(wres)
        }
        return res
    }
    private static func initializeRules(_ productionRules: [ProductionRule<T, U>], _ alphabet: Set<T>) throws -> Dictionary<T, U> {
        var rules : Dictionary<T, U> = Dictionary()
        for rule in productionRules {
            do {
                try rule.validate(alphabet)
                rules[rule.predecessor] = rule.successor
            } catch {
                throw error
            }
            
        }
        return rules
    }
    private static func initializeDictRules(_ rules: [T:U], _ alphabet: Set<T>) throws -> [T:U] {
        for (k, v) in rules {
            let rule = ProductionRule(k, v)
            try rule.validate(alphabet)
        }
        return rules
    }
}

