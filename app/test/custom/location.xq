xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'location'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('LOC32')
	%test:assertEquals('<location id="LOC32" type="county"><name>Armagh</name><within ref="LOC10"/></location>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
			
	(: Valid id :)
	%test:args('LOC32') 
	%test:assertEquals('<location ref="LOC32"><name>Armagh</name></location>')
	
function unit:build-entity-reference($param) {
	data:build-entity-reference(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('location', 'LOC32')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
		
	(: Valid index :)
	%test:args('location')
	%test:assertEquals('<index path="location"><title>Locations</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id :) 
	%test:args('location', '')
	%test:assertXPath("$result/view[@path = 'location']")
	%test:assertXPath("count($result/view/data/entities/location) &gt; 1")
				
	(: Valid path, valid id :)
	%test:args('location', 'LOC32')
	%test:assertXPath("$result/view[@path = 'location/LOC32']")
	%test:assertXPath("count($result/view/data/location) = 1")
	%test:assertXPath("$result/view/data/location[@id = 'LOC32']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
