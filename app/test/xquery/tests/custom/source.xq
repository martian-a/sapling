xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/source";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'source'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('SOU2')
	%test:assertXPath("$result[@id = 'SOU2']")
	%test:assertXPath("$result[count(*) = 2]")
	%test:assertXPath("$result/front-matter[*]")
	%test:assertXPath("$result/body-matter[*]")

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
	
	(: Valid id :)
	%test:args('SOU2')
	%test:assertXPath("$result[@id = 'SOU2']")
	%test:assertXPath("$result[count(*) = 3]")
	%test:assertXPath("$result/front-matter[*]")
	%test:assertXPath("$result/body-matter[*]")
	%test:assertXPath("$result/related[*]")
	%test:assertXPath("$result/related[count(location) &gt; 0]")
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('source', 'SOU1')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};


declare

	(: Reference to a source :)
	%test:args('EVE2')
	%test:assertXPath("$result[count(source) = 1]")
	%test:assertXPath("$result/source[@id = 'SOU1']")
	
	(: Reference from a source :)
	%test:args('LOC5')
	%test:assertXPath("$result[count(source) = 1]")
	%test:assertXPath("$result/source[@id = 'SOU2']")
	
	(: Reference from another source :)
	%test:args('SOU2')
	%test:assertXPath("$result[count(source) = 1]")
	%test:assertXPath("$result/source[@id = 'SOU1']")

function unit:get-related-sources($param) {
	<result>{data:get-related-sources(data:get-entity($param))}</result>
};


declare
		
	(: Valid index :)
	%test:args('SOU2')
	%test:assertXPath("$result[@id = 'SOU2']")
	%test:assertXPath("$result[count(*) = 1]")
	%test:assertXPath("$result/front-matter[*]")
	
function unit:simplify-entity($param) {
    data:simplify-entity(data:get-entity($param))
};


declare
		
	(: Valid index :)
	%test:args('source')
	%test:assertEquals('<index path="source"><title>Sources</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id - INDEX :) 
	%test:args('source', '')
	%test:assertXPath("$result/view[@path = 'source']")
	%test:assertXPath("count($result/view/data/entities/source) &gt; 0")
				
	(: Valid path, valid id - PROFILE :)
	%test:args('source', 'SOU1')
	%test:assertXPath("$result/view[@path = 'source/SOU1']")
	%test:assertXPath("count($result/view/data/source) = 1")
	%test:assertXPath("$result/view/data/source[@id = 'SOU1']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};