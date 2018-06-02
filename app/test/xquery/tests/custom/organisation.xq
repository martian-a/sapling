xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/organisation";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
		
	(: Valid id :)
	%test:assertXPath("$result/*/name() = 'organisation'")

function unit:get-entities() as element()* {
    <result>{data:get-entities()}</result>
};


declare
			
	(: Valid id :)
	%test:args('ORG1')
	%test:assertEquals('<organisation id="ORG1"><name>Holy Roman Empire</name></organisation>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
	
	(: Valid id :)
	%test:args('ORG1')
	%test:assertEquals('<organisation id="ORG1"><name>Holy Roman Empire</name><related><event id="EVE7" type="historical"><date day="28" month="6" year="1519"/><summary><person ref="PER1"/> becomes ruler of the <organisation ref="ORG1"/></summary></event><person id="PER1" year="1500" publish="true"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona></person></related></organisation>') 
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};

declare
		
	(: Valid path, valid id :)
	%test:args('organisation', 'ORG1')
	%test:assertTrue 

function unit:is-valid-id($param1, $param2) {
    data:is-valid-id($param1, $param2)
};



declare
		
	(: Valid index :)
	%test:args('organisation')
	%test:assertEquals('<index path="organisation"><title>Organisations</title><method type="xml"/><method type="html"/></index>')

function unit:get-view($param) {
    data:get-view($param)
};


declare
		
	(: Valid path, no id - INDEX :) 
	%test:args('organisation', '')
	%test:assertXPath("$result/view[@path = 'organisation']")
	%test:assertXPath("count($result/view/data/entities/organisation) &gt; 0")
				
	(: Valid path, valid id - PROFILE :)
	%test:args('organisation', 'ORG1')
	%test:assertXPath("$result/view[@path = 'organisation/ORG1']")
	%test:assertXPath("count($result/view/data/organisation) = 1")
	%test:assertXPath("$result/view/data/organisation[@id = 'ORG1']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
