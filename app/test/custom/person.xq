xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'person'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('PER100')
	%test:assertEquals('<person id="PER100" year="1670"><persona><name><name>Josiah</name><name family="yes">Boosy</name></name><gender>Male</gender></persona></person>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
			
	(: Valid id :)
	%test:args('PER100') 
	%test:assertEquals('<person ref="PER100"><name><name>Josiah</name><name family="yes">Boosy</name></name></person>')
	
function unit:build-entity-reference($param) {
	data:build-entity-reference(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('person', 'PER100')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
		
	(: Valid index :)
	%test:args('person')
	%test:assertEquals('<index path="person"><title>People</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id :) 
	%test:args('person', '')
	%test:assertXPath("$result/view[@path = 'person']")
	%test:assertXPath("count($result/view/data/entities/person) &gt; 1")
				
	(: Valid path, valid id :)
	%test:args('person', 'PER100')
	%test:assertXPath("$result/view[@path = 'person/PER100']")
	%test:assertXPath("count($result/view/data/person) = 1")
	%test:assertXPath("$result/view/data/person[@id = 'PER100']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
