import hxbenchmark.SuiteResult;

typedef BenchCollection = {
	var target:TargetType;
	var benchmarks:Array<{
		name:String,
		suites:Array<SuiteResult>
	}>;
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
