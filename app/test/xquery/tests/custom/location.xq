xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/location";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

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
	%test:args('LOC1')
	%test:assertEquals('<location id="LOC1" type="settlement"><name>Ghent</name><within ref="LOC3"/></location>') 

function unit:get-entity($param) {
    data:get-entity($param)
};



declare

	(: Not a location entity :)
	%test:args('PER10')
	%test:assertEquals('<result/>')

	(: Valid id, no ancestors :)
	%test:args('LOC4')
	%test:assertEquals('<result />') 

	(: Valid id, one ancestor :)
	%test:args('LOC3')
	%test:assertEquals('<result><location id="LOC4" type="continent"><name>Europe</name></location></result>') 

	(: Valid id, more than one ancestor :)
	%test:args('LOC5')
	%test:assertEquals('<result><location id="LOC6" type="settlement"><name>Cuacos de Yuste</name><within ref="LOC7"/></location><location id="LOC7" type="country"><name>Spain</name><within ref="LOC4"/></location><location id="LOC4" type="continent"><name>Europe</name></location></result>') 


function unit:get-location-context($param) {
	<result>{data:get-location-context(data:get-entity($param))}</result>
};


declare

	(: Not a location entity :)
	%test:args('PER10')
	%test:assertEquals('<result/>')

	(: Valid id, no descendants :)
	%test:args('LOC5')
	%test:assertEquals('<result/>') 

	(: Valid id, one descendant :)
	%test:args('LOC6')
	%test:assertEquals('<result><location id="LOC5" type="address"><name>Monastery of Yuste</name><within ref="LOC6"/></location></result>') 

	(: Valid id, more than one descendant :)
	%test:args('LOC7')
	%test:assertEquals('<result><location id="LOC6" type="settlement"><name>Cuacos de Yuste</name><within ref="LOC7"/></location><location id="LOC5" type="address"><name>Monastery of Yuste</name><within ref="LOC6"/></location><location id="LOC8" type="settlement"><name>Seville</name><within ref="LOC7"/></location></result>') 


function unit:get-locations-within($param) {
	<result>{data:get-locations-within(data:get-entity($param))}</result>
};


declare

	(: Not a location entity :)
	%test:args('PER10')
	%test:assertEquals('<result/>')

	(: Valid id, no nearby locations :)
	%test:args('LOC6')
	%test:assertEquals('<result/>') 

	(: Valid id, one nearby location :)
	%test:args('LOC11')
	%test:assertEquals('<result><location id="LOC10" type="settlement"><name>Grenada</name><near ref="LOC8"/></location></result>') 

	(: Valid id, more than one nearby location :)
	%test:args('LOC8')
	%test:assertEquals('<result><location id="LOC9" type="settlement"><name>Cordoba</name><near ref="LOC8"/></location><location id="LOC10" type="settlement"><name>Grenada</name><near ref="LOC8"/></location></result>') 

	(: Valid id, indirectly referenced :)
	%test:args('LOC10')
	%test:assertEquals('<result><location id="LOC8" type="settlement"><name>Seville</name><within ref="LOC7"/></location><location id="LOC11" type="settlement"><name>Cájar</name><near ref="LOC10"/></location></result>') 


function unit:get-locations-near($param) {
	<result>{data:get-locations-near(data:get-entity($param))}</result>
};



declare

	(: No related locations :)
	%test:args('EVE6')
	%test:assertEquals('<result/>')
	
	(: One related location (with context) :)
	%test:args('EVE3')
	%test:assertEquals('<result><location id="LOC1" type="settlement"><name>Ghent</name><within ref="LOC3"/></location><location id="LOC3" type="country"><name>Belgium</name><within ref="LOC4"/></location><location id="LOC4" type="continent"><name>Europe</name></location></result>')



function unit:get-related-locations($param) {
	<result>{data:get-related-locations(data:get-entity($param))}</result>
};


declare
		
	(: Valid path, valid id :)
	%test:args('location', 'LOC3')
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
	%test:args('location', 'LOC1')
	%test:assertXPath("$result/view[@path = 'location/LOC1']")
	%test:assertXPath("count($result/view/data/location) = 1")
	%test:assertXPath("$result/view/data/location[@id = 'LOC1']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
