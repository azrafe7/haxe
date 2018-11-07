import haxe.io.Path;
import haxe.macro.Context;

using StringTools;


class ChartMacro
{
	macro public static function getJsonBenchmarks() {
		#if macro
			var jsonArray = [];
			var path = Context.resolvePath("..");
			for (file in sys.FileSystem.readDirectory(path)) {
				if (file.startsWith("bench_") && file.endsWith(".json")) {
					Sys.println(file);
					var jsonString = sys.io.File.getContent(Path.join([path, file]));
					if (jsonString.length < 2) throw "Invalid json file '" + file + "'";
					jsonArray.push(jsonString);
				}
			}
			return macro $v{jsonArray};
		#else
		return macro null;
		#end
	}
}