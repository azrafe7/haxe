import hxbenchmark.SuiteResult;
import hxbenchmark.ResultPrinter;

class Main {
	static function main() {
		var results:BenchCollection = {
			target: currentTarget,
			benchmarks: []
		};

		var cases = Macro.getCases("cases");
		var printer = new ResultPrinter();

		function print(result:SuiteResult) {
			Sys.println(printer.print(result));
		}

		function printAndCollect(result:SuiteResult, benchName) {
			print(result);
			var benchmark = results.benchmarks.filter((b) -> b.name == benchName);
			if (benchmark.length == 0) results.benchmarks.push({name: benchName, suites:[result]});
			else benchmark[0].suites.push(result);
		}

		for (benchCase in cases) {
			Sys.println('Case: ${benchCase.name}');
			benchCase.exec.run(printAndCollect.bind(_, benchCase.name));
		}

		var prettyJson = haxe.format.JsonPrinter.print(results, null, "  ");
		sys.io.File.saveContent("bench_" + currentTarget + ".json", prettyJson);
	}

	static inline var currentTarget:BenchCollection.TargetType =
		#if eval
			EVAL;
		#elseif flash
			FLASH;
		#elseif (js && nodejs)
			NODEJS;
		#elseif js
			JS;
		#elseif cpp
			CPP;
		#elseif neko
			NEKO;
		#elseif hl
			HL;
		#elseif cs
			CS;
		#elseif java
			JAVA;
		#elseif python
			PYTHON;
		#elseif php
			PHP;
		#elseif lua
			LUA;
		#else
			UNKNOWN;
		#end
}