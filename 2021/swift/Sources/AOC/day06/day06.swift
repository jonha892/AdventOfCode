class Day6: Day{
    init() {
        // super.init(day: 6, test: true)
        super.init(day: 6)
    }

    override func part1() -> Int {
        return self.simulatePopulation(days: 80).count
    }

    override func part2() -> Int {
        let r = try? self.simulatePopulationWithMatrix(days: 256)
        return r?.reduce(0, { (curr, e) in curr + e }) ?? -1
    }

    private func simulatePopulation(days: Int) -> [Int] {
        var population = self.inputLines[0].components(separatedBy: ",").map { Int($0)! }
        // print(population)
        for _ in 1...days {
            var newPopulation: [Int] = []
            for (index, element) in population.enumerated() {
                if (element == 0) {
                    population[index] = 6
                    newPopulation.append(8)
                } else {
                    population[index] = element - 1
                }
            }
            population.append(contentsOf: newPopulation)
            // print("Population", population)
        }
        return population
    }
    private func simulatePopulationWithMatrix(days: Int) throws -> [Int] {
        let school = self.inputLines[0].components(separatedBy: ",").map { Int($0)! }
        let populationMatrix = Matrix(data: [
            [0, 1, 0, 0, 0, 0, 0, 0, 0],
            [0, 0, 1, 0, 0, 0, 0, 0, 0],
            [0, 0, 0, 1, 0, 0, 0, 0, 0],
            [0, 0, 0, 0, 1, 0, 0, 0, 0],
            [0, 0, 0, 0, 0, 1, 0, 0, 0],
            [0, 0, 0, 0, 0, 0, 1, 0, 0],
            [1, 0, 0, 0, 0, 0, 0, 1, 0],
            [0, 0, 0, 0, 0, 0, 0, 0, 1],
            [1, 0, 0, 0, 0, 0, 0, 0, 0],
        ])
        var populationVecData = Array<Int>(repeating: 0, count: 9)
        for current in school {
            populationVecData[current] += 1
        }
        var pop = Vector(data: populationVecData)
        do {
            for _ in 1...days {
                pop = try populationMatrix.times(right: pop)
                // print(pop.data)
            }
            return pop.data
        } catch {
            print(error)
            return []
        }
    }
}