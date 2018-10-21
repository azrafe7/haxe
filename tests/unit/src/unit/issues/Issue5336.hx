package unit.issues;

class Issue5336 extends unit.Test {
	function test() {
		eq(1, haxe.Utf8.compare("a", "A"));
		eq(-1, haxe.Utf8.compare("A", "a"));
	}
}
