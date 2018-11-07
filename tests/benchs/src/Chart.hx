import ChartMacro;
import haxe.Json;

import BenchDB.TestResultInfo;

using StringTools;
using Lambda;


class Chart {

	static var benchDB:BenchDB;

	static function main()
	{
		var jsonArray = ChartMacro.getJsonBenchmarks();

		benchDB = new BenchDB(jsonArray);

		var prettyJson = benchDB.toJson("  ");
		sys.io.File.saveContent("benchdb.json", prettyJson);

		trace(benchDB.suiteNames);

		var results = benchDB.query({suiteName:"Custom(Array<Int>[1000])", target:null});
		trace(haxe.format.JsonPrinter.print(results, null, "  "));
		trace(results.length);
	}
}