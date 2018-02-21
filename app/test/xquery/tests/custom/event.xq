xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/event";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'event'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('EVE3')
	%test:assertEquals('<event id="EVE3" type="historical"><date year="1506"/><summary><person ref="PER1"/> becomes ruler of <location ref="LOC1"/></summary></event>') 

function unit:get-entity($param) {
    data:get-entity($param)
};

(:
declare
			
	(: Birth :)
	%test:args('EVE5') 
	%test:assertEquals('<event ref="EVE101">Richard Sutcliffe is born.</event>')

	(: Christening :)
	%test:args('EVE10') 
	%test:assertEquals('<event ref="EVE10">John Thomson is christened.</event>')

	(: Marriage :)
	%test:args('EVE4') 
	%test:assertEquals('<event ref="EVE1019">Isobella Brown and Thomas Scott marry.</event>')

	(: Historical :)
	%test:args('EVE3') 
	%test:assertEquals('<event id="EVE3" type="historical"><date year="1506"/><summary><person ref="PER1"/> becomes ruler of <location ref="LOC1"/></summary></event></output>')

	(: Death :)
	%test:args('EVE6') 
	%test:assertEquals('<event ref="EVE6">Ferdinand dies.</event>')

function unit:build-index-entry($param) {
	data:build-index-entry(data:get-entity($param))
};
:)


declare
			
	(: Valid id :)
	%test:args('EVE3')
	%test:assertEquals('<event id="EVE3" type="historical"><date year="1506"/><summary><person ref="PER1"/> becomes ruler of <location ref="LOC1"/></summary><related><person id="PER1" year="1500" publish="true"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona></person><location id="LOC1" type="settlement"><name>Ghent</name><within ref="LOC3"/></location><location id="LOC3" type="country"><name>Belgium</name><within ref="LOC4"/></location><location id="LOC4" type="continent"><name>Europe</name></location></related></event>') 

function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('event', 'EVE1')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
		
	(: Valid index :)
	%test:args('event')
	%test:assertEquals('<index path="event"><title>Events</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id :) 
	%test:args('event', '')
	%test:assertXPath("$result/view[@path = 'event']")
	%test:assertXPath("count($result/view/data/entities/event) &gt; 1")
				
	(: Valid path, valid id :)
	%test:args('event', 'EVE1')
	%test:assertXPath("$result/view[@path = 'event/EVE1']")
	%test:assertXPath("count($result/view/data/event) = 1")
	%test:assertXPath("$result/view/data/event[@id = 'EVE1']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
