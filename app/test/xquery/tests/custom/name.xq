xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/name";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'name'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('josiah')
	%test:assertEquals('<name id="josiah"><name>Josiah</name><derived-from><person ref="PER100"/></derived-from></name>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
	
	(: Valid id :)
	%test:args('angus')
	%test:assertEquals('<name id="angus"><name>Angus</name><derived-from><person ref="PER629"/><location ref="LOC55"/></derived-from><related><person id="PER629" year="1800"><persona><name><name>Angus</name><name family="yes">McKay</name></name><gender>Male</gender></persona></person><location id="LOC1" type="continent"><name>Europe</name></location><location id="LOC9" type="country"><name>Scotland</name><within ref="LOC213"/></location><location id="LOC55" type="county"><name>Angus</name><within ref="LOC9"/></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC213" type="country"><name>Great Britain</name><within ref="LOC191"/></location></related></name>') 
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};

declare
		
	(: Valid path, valid id :)
	%test:args('name', 'josiah')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
		
	(: Valid index :)
	%test:args('name')
	%test:assertEquals('<index path="name"><title>Names</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id :) 
	%test:args('name', '')
	%test:assertXPath("$result/view[@path = 'name']")
	%test:assertXPath("count($result/view/data/entities/name) &gt; 1")
				
	(: Valid path, valid id :)
	%test:args('name', 'josiah')
	%test:assertXPath("$result/view[@path = 'name/josiah']")
	%test:assertXPath("count($result/view/data/name) = 1")
	%test:assertXPath("$result/view/data/name[@id = 'josiah']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
