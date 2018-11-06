import hxbenchmark.SuiteResult;
import hxbenchmark.ResultPrinter;

class Main {
	static function main() {
		var results = new Map();
		var currTarget = detectedTarget();

		var cases = Macro.getCases("cases");
		var printer = new ResultPrinter();
		function print(result:SuiteResult) {
			Sys.println(printer.print(result));
		}

		function printAndCollect(result:SuiteResult, benchCase) {
			print(result);
			var currCase = results[benchCase];
			if (currCase == null) results[benchCase] = currCase = new Map();
			if (!currCase.exists(currTarget)) currCase[currTarget] = [];
			currCase[currTarget].push(result);
		}

		for (benchCase in cases) {
			Sys.println('Case: ${benchCase.name}');
			benchCase.exec.run(printAndCollect.bind(_, benchCase.name));
		}

		//Sys.println(results);
		var prettyJson = haxe.format.JsonPrinter.print(results, null, "  ");
		sys.io.File.saveContent("bench_" + currTarget + ".json", prettyJson);
	}

	static function detectedTarget():String {
	// @formatter:off
		return
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
	// @formatter:on
	}
}

@:enum abstract TargetType(String) to String {
	var EVAL = "eval";
	var FLASH = "flash";
	var NODEJS = "nodejs";
	var JS = "js";
	var CPP = "cpp";
	var NEKO = "neko";
	var HL = "hl";
	var CS = "cs";
	var JAVA = "java";
	var PYTHON = "python";
	var PHP = "php";
	var LUA = "lua";
	var UNKNOWN = "unknown";
}
