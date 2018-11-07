import haxe.Json;

import BenchCollection;
import BenchCollection.TargetType;
import hxbenchmark.CaseResult;

using StringTools;
using Lambda;


typedef TestResultInfo = {
	var target:TargetType;
	var benchName:String;
	var suiteName:String;
	var caseName:String;
	var numSamples:Int;
}

typedef TestEntry = {
	var targetID:Int;
	var benchID:Int;
	var suiteID:Int;
	var caseID:Int;
	var numSamples:Int;
}


class BenchDB {

	public var targets:Map<TargetType, Int> = [];
	public var benchNames:Map<String, Int> = [];
	public var suiteNames:Map<String, Int> = [];
	public var caseNames:Map<String, Int> = [];
	public var tests:Array<TestEntry> = [];

	public function new(jsonArray:Array<String>) {
		if (jsonArray == null || jsonArray.length == 0) throw "No bench data found!";

		var targetID = 0;
		var benchID = 0;
		var suiteID = 0;
		var caseID = 0;

		for (jsonString in jsonArray) {
			var bc:BenchCollection = haxe.Json.parse(jsonString);

			if (!this.targets.exists(bc.target)) this.targets[bc.target] = targetID++;
			for (bench in bc.benchmarks) {
				if (!this.benchNames.exists(bench.name)) this.benchNames[bench.name] = benchID++;
				for (suite in bench.suites) {
					if (!this.suiteNames.exists(suite.name)) this.suiteNames[suite.name] = suiteID++;
					for (testcase in suite.cases) {
						if (!this.caseNames.exists(testcase.name)) this.caseNames[testcase.name] = caseID++;
						var testEntry:TestEntry = {
							targetID: targetID - 1,
							benchID: benchID - 1,
							suiteID: suiteID - 1,
							caseID: caseID - 1,
							numSamples: testcase.numSamples
						}
						this.tests.push(testEntry);
					}
				}
			}
		}
	}

	public function toJson(space:String = null):String {
		var db = {
			targets:targets,
			benchNames:benchNames,
			suiteNames:suiteNames,
			caseNames:caseNames,
			tests:tests
		};

		var prettyJson = haxe.format.JsonPrinter.print(db, null, space);
		return prettyJson;
	}

	public function getTestBy(targetID, benchID, suiteID, caseID):Null<TestResultInfo> {
		var results = tests.filter((t) ->
			(t.targetID == targetID) &&
			(t.benchID == benchID) &&
			(t.suiteID == suiteID) &&
			(t.caseID == caseID)
		);

		if (results.length > 0) {
			var t = results[0];
			return toTestResultInfo(t);
		} else {
			return null;
		}
	}

	static public function toTestResultInfo(t:TestEntry):TestResultInfo
	{
		return null;
	}
}