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
	%test:args('person/PER2')
	%test:assertEquals('<person id="PER2" year="1500"><persona><name xml:lang="en"><name>Isabella</name><origin><particle>of</particle><location>Portugal</location></origin></name><gender>Female</gender></persona><related><event id="EVE4" type="marriage"><date day="10" month="3" year="1526"/><person ref="PER1"/><person ref="PER2"/><location ref="LOC8"/></event><person id="PER1" year="1500"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona></person><location id="LOC4" type="continent"><name>Europe</name></location><location id="LOC7" type="country"><name>Spain</name><within ref="LOC4"/></location><location id="LOC8" type="settlement"><name>Seville</name><within ref="LOC7"/></location></related></person>') 
	
function unit:request-xml($param) {
    action:request-xml($param)
};