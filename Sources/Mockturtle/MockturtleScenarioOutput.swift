//
//  MockturtleScenarioOutput.swift
//  Mockturtle
//
//  Created by Christoph Pageler on 30.01.19.
//


import Foundation


public class MockturtleScenarioOutput: Codable {

    public let scenarios: [String: Scenario]

    public init(scenarios: [String: Scenario]) {
        self.scenarios = scenarios
    }

    public func stateIdentifierFor(scenarioIdentifier: String,
                                   method: String,
                                   path: String) -> String? {
        guard let scenario = scenarios[scenarioIdentifier] else { return nil }

        for route in scenario.routes {
            let isURLMatching = path.contains(route.path)
            let isMethodEmpty = route.method == "" || route.method == nil
            let isMethodMatching = method.uppercased() == route.method?.uppercased()

            if isURLMatching && (isMethodMatching || isMethodEmpty) {
                return route.state
            }
        }

        return nil
    }

}


public extension MockturtleScenarioOutput {

    public class Scenario: Codable {

        public let routes: [Route]

        public init(routes: [Route]) {
            self.routes = routes
        }

    }

    public class Route: Codable {

        public let path: String
        public let method: String?
        public let state: String

        public init(path: String, method: String?, state: String) {
            self.path = path
            self.method = method
            self.state = state
        }

    }

}
