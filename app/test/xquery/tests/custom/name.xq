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
	%test:args('NAM9')
	%test:assertXPath("$result[@id = 'NAM9']")

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
	
	(: Valid id :)
	%test:args('Ghent')
    %test:assertXPath("$result[@key = 'ghent']")
    %test:assertXPath("$result/derived-from[location/@ref = 'LOC1']")
    %test:assertXPath("$result/related[location/@id = 'LOC1']")
    %test:assertXPath("$result/related[location/@id = 'LOC3']")
    %test:assertXPath("$result/related[location/@id = 'LOC4']")	
    %test:assertXPath("$result/related[count(*) = 3]")

function unit:augment-entity($name) {

    let $param := data:get-entities('name')[name = $name]
    return data:augment-entity(data:get-entity($param))
};

declare
		
	(: Valid path, invalid id :)
	%test:args('name', 'PER10')
	%test:assertFalse 
		
		
	(: Valid path, valid id :)
	%test:args('name', 'NAM10')
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
	%test:args('name', 'NAM9')
	%test:assertXPath("$result/view[@path = 'name/NAM9']")
	%test:assertXPath("count($result/view/data/name) = 1")
	%test:assertXPath("$result/view/data/name[@id = 'NAM9']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
