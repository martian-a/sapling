xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/location";

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

	(: Not a location entity :)
	%test:args('PER10')
	%test:assertEquals('<result/>')

	(: Valid id, no ancestors :)
	%test:args('LOC1')
	%test:assertEquals('<result />') 

	(: Valid id, one ancestor :)
	%test:args('LOC200')
	%test:assertEquals('<result><location id="LOC1" type="continent"><name>Europe</name></location></result>') 

	(: Valid id, more than one ancestor :)
	%test:args('LOC180')
	%test:assertEquals('<result><location id="LOC128" type="settlement"><name>London</name><within ref="LOC24"/></location><location id="LOC24" type="county"><name>Greater London</name><within ref="LOC7"/></location><location id="LOC7" type="country"><name>England</name><within ref="LOC213"/></location><location id="LOC213" type="country"><name>Great Britain</name><within ref="LOC191"/></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC1" type="continent"><name>Europe</name></location></result>') 


function unit:get-location-context($param) {
	<result>{data:get-location-context(data:get-entity($param))}</result>
};


declare

	(: Not a location entity :)
	%test:args('PER10')
	%test:assertEquals('<result/>')

	(: Valid id, no descendants :)
	%test:args('LOC180')
	%test:assertEquals('<result/>') 

	(: Valid id, one descendant :)
	%test:args('LOC200')
	%test:assertEquals('<result><location id="LOC201" type="settlement"><name>Padua</name><within ref="LOC200"/></location></result>') 

	(: Valid id, more than one descendant :)
	%test:args('LOC128')
	%test:assertEquals('<result><location id="LOC175" type="district"><name>Highbury</name><within ref="LOC128"/></location><location id="LOC177" type="district"><name>Finchley</name><within ref="LOC128"/></location><location id="LOC179" type="district"><name>Hampton Court</name><within ref="LOC128"/></location><location id="LOC180" type="district"><name>Belsize Park</name><within ref="LOC128"/></location></result>') 


function unit:get-locations-within($param) {
	<result>{data:get-locations-within(data:get-entity($param))}</result>
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
