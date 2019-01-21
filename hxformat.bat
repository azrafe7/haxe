REM haxelib run formatter -s extra -s std -s tests %*
haxelib run formatter -s std\sys\Http.hx -s std\StringTools.hx -s std\Xml.hx -s std\UInt.hx -s std\eval\_std\sys\net\Socket.hx -s std\neko\Web.hx %*
haxelib run formatter -s tests\benchs\src\hxbenchmark\Suite.hx -s tests\unit\src\RunSauceLabs.hx -s std\haxe\ds\Vector.hx %*