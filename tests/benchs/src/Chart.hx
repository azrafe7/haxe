import ChartMacro;
import haxe.Json;

import BenchCollection;
import BenchCollection.TargetType;
import hxbenchmark.CaseResult;

using StringTools;
using Lambda;


typedef TestEntry = {
	var targetID:Int;
	var benchID:Int;
	var suiteID:Int;
	var caseID:Int;
	var caseResult:CaseResult;
}

typedef BenchDB = {
	var targets:Map<TargetType, Int>;
	var benchNames:Map<String, Int>;
	var suiteNames:Map<String, Int>;
	var caseNames:Map<String, Int>;
	var tests:Array<TestEntry>;
}


class Chart {

	static function main()
	{
		var jsonArray = ChartMacro.getJsonBenchmarks();

		var benchDB = buildBenchDB(jsonArray);
		//trace(merged);

	}

	static function buildBenchDB(jsonArray:Array<String>):BenchDB {
		if (jsonArray == null || jsonArray.length == 0) throw "No bench data found!";

		var targetID = 0;
		var benchID = 0;
		var suiteID = 0;
		var caseID = 0;
		var tests = [];

		var benchDB:BenchDB = {
			targets:new Map(),
			benchNames:new Map(),
			suiteNames:new Map(),
			caseNames:new Map(),
			tests:tests
		};

		for (jsonString in jsonArray) {
			var bc:BenchCollection = haxe.Json.parse(jsonString);

			if (!benchDB.targets.exists(bc.target)) benchDB.targets[bc.target] = targetID++;
		}
		return null;
	}
}