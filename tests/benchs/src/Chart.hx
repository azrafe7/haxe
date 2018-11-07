import ChartMacro;
import haxe.Json;

#if js
import js.Browser;
#end

import BenchCollection.TargetType;
import BenchDB.TestInfo;

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


@:expose
@:native("Chart")
class Chart {

	static var benchDB:BenchDB;
	static var colors:Map<TargetType, String> = [];
	static var displayOrder = [
		TargetType.CPP,
		TargetType.JS,
		TargetType.NODEJS,
		TargetType.CS,
		TargetType.JAVA,
		TargetType.FLASH,
		TargetType.HL,
		TargetType.NEKO,
		TargetType.EVAL,
		TargetType.PHP,
		TargetType.PYTHON,
		TargetType.LUA,
		TargetType.UNKNOWN
	];

	static function main()
	{
		var jsonArray = ChartMacro.getJsonBenchmarks();

		benchDB = new BenchDB(jsonArray);

		var prettyJson = benchDB.toJson("  ");
	#if sys
		sys.io.File.saveContent("benchdb.json", prettyJson);
	#end

		trace(benchDB.suiteNames);

		setupColors();

		var results = benchDB.query({suiteName:"json"});
		trace(haxe.format.JsonPrinter.print(results, null, "  "));
		trace(results.length);

		results = benchDB.queryFunc((t:TestInfo) -> {
			return t.benchName.startsWith("Custom") && t.suiteName.indexOf("Int") > 0;
		});
		trace(haxe.format.JsonPrinter.print(results, null, "  "));
		trace(results.length);

		var testData = prepareDataFor(results[0].suiteName);
		trace(haxe.format.JsonPrinter.print(testData, null, "  "));


		var options = {
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

		setupChart(testData);
	}

	static function setupColors() {
		colors[TargetType.CPP] = '#F34B7D';
		colors[TargetType.JS] = '#CC4125';
		colors[TargetType.NODEJS] = colors[TargetType.JS];
		colors[TargetType.FLASH] = '#E01';
		colors[TargetType.CS] = '#178600';
		colors[TargetType.JAVA] = '#B07219';
		colors[TargetType.HL] = '#FF9900';
		colors[TargetType.NEKO] = '#A64D79';
		colors[TargetType.PYTHON] = '#3572A5';
		colors[TargetType.EVAL] = '#342628';
		colors[TargetType.LUA] = '#DCC';
		colors[TargetType.PHP] = '#1B52A5';
		colors[TargetType.UNKNOWN] = '#fff';
	}

	static function prepareDataFor(suite:String, ?filterTargets:Array<TargetType>):Dynamic {
		var results = benchDB.queryFunc((t:TestInfo) -> {
			return t.suiteName == suite && (filterTargets == null || filterTargets.filter(x -> x == t.target).length > 0);
		});

		if (results.length == 0) return null;

		var uniqueCaseNames = [];
		var mapByTarget = new Map<TargetType, Map<String, TestInfo>>();
		for (t in results) {
			if (!mapByTarget.exists(t.target)) {
				mapByTarget[t.target] = new Map();
			}
			mapByTarget[t.target][t.caseName] = t;

			if (uniqueCaseNames.indexOf(t.caseName) < 0) {
				uniqueCaseNames.push(t.caseName);
			}
		}

		trace(uniqueCaseNames);

		var collectedData:Dynamic = {

		};

		var labelOptions = {
			normal: {
				show: true,
				position: 'top',
				distance: 10,
				align: 'center',
				verticalAlign: 'middle',
			}
		};
		var labelNames = [];
		var barColors = [];
		var series = [];
		var xAxisLabels = uniqueCaseNames;
		var targetIdx = -1;
		for (target in displayOrder) {
			if (mapByTarget.exists(target)) {
				targetIdx++;
				labelNames.push(target);
				barColors.push(colors[target]);
				for (caseName in uniqueCaseNames) {
					if (series.length <= targetIdx) series[targetIdx] = [];
					series[targetIdx].push(mapByTarget[target][caseName].numSamples);
				}
			}
		}
		var seriesOptions:Dynamic = [];
		for (i in 0...series.length) {
			var s = series[i];
			seriesOptions.push({
				name: labelNames[i],
				type: 'bar',
				barGap: 0,
				label: labelOptions,
				data: s
			});
		}

		trace(series);

		var options = {
			color: barColors,
			tooltip: {
				trigger: 'axis',
				axisPointer: {
					type: 'shadow'
				}
			},
			legend: {
				data: labelNames
			},
			xAxis: [
				{
					type: 'category',
					axisTick: {show: false},
					axisLabel: {
						rotate: 0
					},
					data: uniqueCaseNames,
				}
			],
			yAxis: [
				{
					type: 'value'
				}
			],
			series: seriesOptions
		};

		return options;
	}

	static function setupChart(options) {
	#if js
		var chartDiv = Browser.document.getElementById("chart");
		trace(chartDiv);
		var chart = EChartsInit.init(chartDiv);

		// use configuration item and data specified to show chart
		chart.setOption(options);

		return chart;
	#end
	}
}