//
//  MockturtleRequestAdapter.swift
//  Mockturtle
//
//  Created by Christoph Pageler on 30.01.19.
//


#if canImport(Alamofire)

import Foundation
import Alamofire


public class MockturtleRequestAdapter: RequestAdapter {

    public let scenarioOutput: MockturtleScenarioOutput

    public var scenarioIdentifier: String?

    public init(_ scenarioOutput: MockturtleScenarioOutput, scenarioIdentifier: String? = nil) {
        self.scenarioOutput = scenarioOutput
        self.scenarioIdentifier = scenarioIdentifier
    }

    public convenience init?(_ scenarioIdentifier: String? = nil) {
        let defaultFileURL = Bundle.main.url(forResource: "output", withExtension: "json")
        self.init(scenarioFileURL: defaultFileURL, scenarioIdentifier: scenarioIdentifier)
    }

    public convenience init?(scenarioFileURL: URL?, scenarioIdentifier: String? = nil) {
        guard let url = scenarioFileURL else { return nil }
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        guard let output = try? JSONDecoder().decode(MockturtleScenarioOutput.self, from: data) else { return nil }

        self.init(output, scenarioIdentifier: scenarioIdentifier)
    }

    public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        guard let scenarioIdentifier = scenarioIdentifier else { return urlRequest }
        guard let path = urlRequest.url?.path else { return urlRequest }
        guard let httpMethod = urlRequest.httpMethod else { return urlRequest }
        guard let identifier = scenarioOutput.stateIdentifierFor(scenarioIdentifier: scenarioIdentifier,
                                                                 method: httpMethod,
                                                                 path: path)
            else {
                return urlRequest
        }

        var request = urlRequest
        request.addValue(identifier, forHTTPHeaderField: "x-mockturtle-state-identifier")
        return request
    }

}


#endif
