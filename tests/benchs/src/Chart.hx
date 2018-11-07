import ChartMacro;
import haxe.Json;
import js.Browser;

import BenchDB.TestResultInfo;

using StringTools;
using Lambda;


@:native("echarts")
extern class EChartsInit {
	static public function init(dom:Dynamic):ECharts;
}

@:native("ECharts")
extern class ECharts {
	public function setOption(options:Dynamic):Dynamic;
}


class Chart {

	static var benchDB:BenchDB;

	static function main()
	{
		var jsonArray = ChartMacro.getJsonBenchmarks();

		benchDB = new BenchDB(jsonArray);

		var prettyJson = benchDB.toJson("  ");
	#if sys
		sys.io.File.saveContent("benchdb.json", prettyJson);
	#end

		trace(benchDB.suiteNames);

		var results = benchDB.query({suiteID:benchDB.suiteNames["json"]});
		trace(haxe.format.JsonPrinter.print(results, null, "  "));
		trace(results.length);

		var chartDiv = Browser.document.getElementById("chart");
		trace(chartDiv);
		var chart = EChartsInit.init(chartDiv);


		var option = {
			title: {
					text: 'ECharts entry example'
			},
			tooltip: {},
			legend: {
					data:['Sales']
			},
			xAxis: {
					data: ["shirt","cardign","chiffon shirt","pants","heels","socks"]
			},
			yAxis: {},
			series: [{
					name: 'Sales',
					type: 'bar',
					data: [5, 20, 36, 10, 10, 20]
			}]
		};

		// use configuration item and data specified to show chart
		chart.setOption(option);
	}
}