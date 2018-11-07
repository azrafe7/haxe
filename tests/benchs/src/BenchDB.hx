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

typedef BenchDBQuery = {
	@:optional var targetID:Int;
	@:optional var benchID:Int;
	@:optional var suiteID:Int;
	@:optional var caseID:Int;

	@:optional var target:String;
	@:optional var benchName:String;
	@:optional var suiteName:String;
	@:optional var caseName:String;
}

class BenchDB {

	public var targets:Map<TargetType, Int> = [];
	public var benchNames:Map<String, Int> = [];
	public var suiteNames:Map<String, Int> = [];
	public var caseNames:Map<String, Int> = [];
	public var tests:Array<TestEntry> = [];

	var targetsById:Map<Int, TargetType> = [];
	var benchNamesById:Map<Int, String> = [];
	var suiteNamesById:Map<Int, String> = [];
	var caseNamesById:Map<Int, String> = [];

	public function new(jsonArray:Array<String>) {
		if (jsonArray == null || jsonArray.length == 0) throw "No bench data found!";

		var targetID = 0;
		var benchID = 0;
		var suiteID = 0;
		var caseID = 0;

		for (jsonString in jsonArray) {
			var bc:BenchCollection = haxe.Json.parse(jsonString);

			if (!this.targets.exists(bc.target)) this.targets[bc.target] = targetID;
			for (bench in bc.benchmarks) {
				if (!this.benchNames.exists(bench.name)) this.benchNames[bench.name] = benchID;
				for (suite in bench.suites) {
					if (!this.suiteNames.exists(suite.name)) this.suiteNames[suite.name] = suiteID;
					for (testcase in suite.cases) {
						if (!this.caseNames.exists(testcase.name)) this.caseNames[testcase.name] = caseID;
						var testEntry:TestEntry = {
							targetID: targetID,
							benchID: benchID,
							suiteID: suiteID,
							caseID: caseID,
							numSamples: testcase.numSamples
						}
						this.tests.push(testEntry);

						// update mapsById
						targetsById[targetID] = bc.target;
						benchNamesById[benchID] = bench.name;
						suiteNamesById[suiteID] = suite.name;
						caseNamesById[caseID] = testcase.name;

						caseID++;
					}
					suiteID++;
				}
				benchID++;
			}
			targetID++;
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

	public function query(q:BenchDBQuery):Array<TestResultInfo> {
		var results = tests.filter((t) ->
			(q.targetID == null || q.targetID == t.targetID) &&
			(q.benchID  == null || q.benchID == t.benchID) &&
			(q.suiteID  == null || q.suiteID == t.suiteID) &&
			(q.caseID   == null || q.caseID == t.caseID) &&

			(q.target    == null || q.target == targetsById[t.targetID]) &&
			(q.benchName == null || q.benchName == benchNamesById[t.benchID]) &&
			(q.suiteName == null || q.suiteName == suiteNamesById[t.suiteID]) &&
			(q.caseName  == null || q.caseName == caseNamesById[t.caseID])
		);

		return results.map(toTestResultInfo);
	}

	public function toTestResultInfo(t:TestEntry):TestResultInfo {
		return {
			target: targetsById[t.targetID],
			benchName: benchNamesById[t.benchID],
			suiteName: suiteNamesById[t.suiteID],
			caseName: caseNamesById[t.caseID],
			numSamples: t.numSamples,
		}
	}
}