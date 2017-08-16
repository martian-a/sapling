xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/event";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

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
	%test:args('EVE1200')
	%test:assertEquals('<event type="historical" id="EVE1200"><date year="1800"/><summary><person ref="PER52" /> runs away to sea (aged 9).</summary></event>') 

function unit:get-entity($param) {
    data:get-entity($param)
};

(:
declare
			
	(: Birth :)
	%test:args('EVE101') 
	%test:assertEquals('<event ref="EVE101">Richard Sutcliffe is born.</event>')

	(: Christening :)
	%test:args('EVE10') 
	%test:assertEquals('<event ref="EVE10">John Thomson is christened.</event>')

	(: Marriage :)
	%test:args('EVE1019') 
	%test:assertEquals('<event ref="EVE1019">Isobella Brown and Thomas Scott marry.</event>')

	(: Historical :)
	%test:args('EVE1200') 
	%test:assertEquals('<event ref="EVE1200">John Allen runs away to sea (aged 9).</event>')

	(: Death :)
	%test:args('EVE100') 
	%test:assertEquals('<event ref="EVE100">Jane Sutcliffe dies.</event>')

function unit:build-index-entry($param) {
	data:build-index-entry(data:get-entity($param))
};
:)


declare
			
	(: Valid id :)
	%test:args('EVE1200')
	%test:assertEquals('<event type="historical" id="EVE1200"><date year="1800"/><summary><person ref="PER52"/> runs away to sea (aged 9).</summary><related><person id="PER52" year="1791"><persona><name><name>John</name><name family="yes">Allen</name></name><gender>Male</gender></persona></person></related></event>') 

function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('event', 'EVE1200')
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
	%test:args('event', 'EVE1200')
	%test:assertXPath("$result/view[@path = 'event/EVE1200']")
	%test:assertXPath("count($result/view/data/event) = 1")
	%test:assertXPath("$result/view/data/event[@id = 'EVE1200']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
