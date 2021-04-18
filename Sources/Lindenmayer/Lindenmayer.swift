class LSystem<T: Hashable & Equatable, U: Collection & Equatable & Take>
    where U.Element == T, U.T == T
{
    private let rules: [T : U];
    public let axiom : U;
    public var state : U;
    public let alphabet: Set<T>;
    init<V: Collection>(alphabet: V, validator: Optional<(T) -> Bool> = nil, axiom: U, productionRules: [ProductionRule<T,U>]) throws where V.Element == T{
        self.alphabet = Set(alphabet)
        self.axiom = axiom
        self.state = axiom
        do {
            self.rules = try LSystem.initializeRules(productionRules, self.alphabet)
        } catch {
            throw error
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
}

