xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/action";

import module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action" at "/db/apps/sapling/modules/action.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
	
	(: No path :)
	%test:args('')
	%test:assertEmpty
	
	(: Invalid path :)
	%test:args('invalid')
	%test:assertEmpty
	
	(: Valid path :)
	%test:args('person/PER100')
	%test:assertEquals('<person id="PER100" year="1670"><persona><name><name>Josiah</name><name family="yes">Boosy</name></name><gender>Male</gender></persona><related><event type="birth" id="EVE175"><person ref="PER101"/><parent type="biological" ref="PER100"/></event><person id="PER101" year="1695"><persona><name><name>Nathaniel</name><name family="yes">Boosy</name></name><gender>Male</gender></persona></person></related></person>') 
	
function unit:request-xml($param) {
    action:request-xml($param)
};