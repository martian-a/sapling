xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: No id :)
	%test:assertXPath("count($result/*) &gt; 1") 
	%test:assertXPath("$result/person") 
	%test:assertXPath("$result/location")
	%test:assertXPath("$result/event")
	%test:assertXPath("$result/organisation") 

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
	
	(: No id :)
	%test:args('')
	%test:assertEmpty
	
	(: Invalid id :)
	%test:args('IND3')
	%test:assertEmpty
		
	(: Valid id - Person :)
	%test:args('PER2')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'PER2'") 
	
	(: Valid id - Location :)
	%test:args('LOC1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'LOC1'") 
	
	(: Valid id - Organisation :)
	%test:args('ORG1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'ORG1'") 
	
	(: Valid id - Event :)
	%test:args('EVE1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'EVE1'") 
	
	(: Valid id - Name :)
	%test:args('NAM1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'NAM1'")
	
	(: Valid id - Source :)
	%test:args('SOU1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'SOU1'") 

	(: Valid id - Journal :)
	%test:args('JOU1')
	%test:assertXPath("count($result) = 1")
	%test:assertXPath("$result/@id = 'JOU1'") 

function unit:get-entity-from-string($param) {
    data:get-entity($param)
};

declare
	
	(: Empty id :)
	%test:args('entity', '')
	%test:assertEmpty
	
	(: Invalid id :)
	%test:args('person', 'IND3')
	%test:assertEmpty
		
	(: Valid id :)
	%test:args('person', 'PER2')
	%test:assertXPath("count($result/*) = 1")
	%test:assertXPath("$result/@id = 'PER2'") 
	
function unit:get-entity-from-element($name, $id) {
	let $element :=
		element {$name} {
			if ($id != '')
			then attribute {"id"} {$id}
			else ()
		}
	return data:get-entity($element)
};


declare

	(: Empty arguments :)
	%test:args('', '')
	%test:assertFalse
	
	(: Valid path, no id :)
	%test:args('person', '')
	%test:assertFalse
	
	(: Valid path, invalid id :)
	%test:args('person', 'IND3')
	%test:assertFalse
	
	(: Invalid path, valid id :)
	%test:args('sourced', 'PER100')
	%test:assertFalse
	
	(: Invalid path, invalid id :)
	%test:args('source', 'IND3')
	%test:assertFalse
	
	(: Valid path, valid but mismatched id (matches another path) :)
	%test:args('person', 'LOC1')
	%test:assertFalse
		
	(: Valid path, valid id :)
	%test:args('person', 'PER1')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
	
	(: No path :)
	%test:args('')
	%test:assertEmpty
	
	(: Home page :)
	%test:args('/')
	%test:assertXPath("$result/self::index[@default = 'true']")
	%test:assertXPath("$result/title")
	
	(: Valid index :)
	%test:args('person')
	%test:assertXPath("$result/self::index[not(@default = 'true')]")
	%test:assertXPath("$result/@path = 'person'")
	%test:assertXPath("$result/title")
	
	(: Invalid index :)
	%test:args('sourced')
	%test:assertEmpty

function unit:get-view($param) {
    data:get-view($param)
};


declare
	
	(: Empty arguments :)
	%test:args('', '')
	%test:assertEmpty
	
	(: Valid path, no id :) 
	%test:args('person', '')
	%test:assertXPath("$result/name() = 'app'")
	%test:assertXPath("count($result/view) = 1")
	%test:assertXPath("$result/view[@path = 'person'][@index = 'true']")
	%test:assertXPath("$result/view[method/@type = 'html' and method/@type = 'xml']")
	%test:assertXPath("count($result/view/data) = 1")
	%test:assertXPath("count($result/view/data/entities) = 1")
	%test:assertXPath("count($result/view/data/entities/*) &gt; 1")
	%test:assertXPath("count($result/views) = 1")
		
	(: Valid path, invalid id :)
	%test:args('person', 'IND3')
	%test:assertEmpty
	
	(: Invalid path, valid id :)
	%test:args('sourced', 'PER1')
	%test:assertEmpty
	
	(: Invalid path, invalid id :) 
	%test:args('sourced', 'IND3')
	%test:assertEmpty
	
	(: Valid path, valid but mismatched id (matches another path) :)
	%test:args('person', 'LOC1')
	%test:assertEmpty
		
	(: Valid path, valid id :)
	%test:args('person', 'PER2')
	%test:assertXPath("$result/name() = 'app'")
	%test:assertXPath("count($result/view) = 1")
	%test:assertXPath("$result/view[@path = 'person/PER2'][@index = 'false']")
	%test:assertXPath("$result/view[method/@type = 'html' and method/@type = 'xml']")
	%test:assertXPath("count($result/view/data) = 1")
	%test:assertXPath("count($result/view/data/person) = 1")
	%test:assertXPath("$result/view/data/person[@id = 'PER2']")
	%test:assertXPath("count($result/views) = 1")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
