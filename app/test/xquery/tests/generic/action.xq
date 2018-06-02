xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/action";

import module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action" at "/db/apps/sapling-test/modules/action.xq";

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
	%test:args('person/PER4')
	%test:assertEquals('<person id="PER4" year="1529" publish="true"><persona><name><name>Ferdinand</name></name></persona><related><event id="EVE5" type="birth"><date day="22" month="11" year="1529"/><person ref="PER4"/><parent type="biological" ref="PER1"/><parent type="biological" ref="PER2"/></event><event id="EVE6" type="death"><date year="1530"/><person ref="PER4"/></event><person id="PER1" year="1500" publish="true"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona></person><person id="PER2" year="1530" publish="true"><persona><name xml:lang="en"><name>Isabella</name><origin><particle>of</particle><location>Portugal</location></origin></name><gender>Female</gender></persona></person></related></person>') 
	
function unit:request-xml($param) {
    action:request-xml($param)
};