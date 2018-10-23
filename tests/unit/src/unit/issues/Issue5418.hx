package unit.issues;

class Issue5418 extends unit.Test {
	var TEST_FILE = "readline_test.txt";

	#if (sys || nodejs)
	function testIssue() {
		trace("TEST");
		var testContent = "line1\nline2\n";
		var expectedLines = ["line1", "line2"];

		sys.io.File.saveContent(TEST_FILE, testContent);

		var is = sys.io.File.read(TEST_FILE, false);

		var lines = [];
		while (!is.eof()) {
			lines.push(is.readLine());
		}

		var expected = expectedLines;
		aeq(expected, lines);

		// seek should reset eof
		trace("SEEK");
		is.seek(0, sys.io.FileSeek.SeekBegin);
		aeq([expectedLines[0]], [is.readLine()]);

		is.close();
	}
	#end
}
