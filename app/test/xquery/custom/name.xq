xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/name";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

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
	%test:assertEquals('<name id="josiah"><name>Josiah</name><related><person ref="PER100"/></related></name>') 

function unit:get-entity($param) {
    data:get-entity($param)
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
