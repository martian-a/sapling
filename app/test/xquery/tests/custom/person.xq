xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/person";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling-test/modules/data.xq";

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
	%test:args('PER2')
	%test:assertEquals('<person id="PER2" year="1530" publish="true"><persona><name xml:lang="en"><name>Isabella</name><origin><particle>of</particle><location>Portugal</location></origin></name><gender>Female</gender></persona></person>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare

	(: Valid id :)
	%test:args('PER2')
	%test:assertEquals('<result><person id="PER1" year="1500" publish="true"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona><persona><name xml:lang="en"><name>Charles</name><origin><particle>of</particle><location>Ghent</location></origin></name><gender>Male</gender></persona><persona><name xml:lang="en"><name>Charles</name><origin><particle>of</particle><location>Spain</location></origin></name><gender>Male</gender></persona></person><person id="PER4" year="1529" publish="true"><persona><name><name>Ferdinand</name></name></persona></person></result>') 

function unit:get-related-people($param) {
	<result>{data:get-related-people(data:get-entity($param))}</result>
};



declare
			
	(: Valid id :)
	%test:args('PER1')
	%test:assertEquals('<person id="PER1" year="1500" publish="true"><persona><name xml:lang="en"><name>Charles</name><ordinal>V</ordinal>, <title>Holy Roman Emperor</title></name><gender>Male</gender></persona><persona><name xml:lang="en"><name>Charles</name><origin><particle>of</particle><location>Ghent</location></origin></name><gender>Male</gender></persona><persona><name xml:lang="en"><name>Charles</name><origin><particle>of</particle><location>Spain</location></origin></name><gender>Male</gender></persona><related><event id="EVE1" type="birth"><date day="24" month="2" year="1500"/><person ref="PER1"/><location ref="LOC1"/></event><event id="EVE2" type="death"><date day="21" month="9" year="1558"/><person ref="PER1"/><location ref="LOC5"/></event><event id="EVE3" type="historical"><date year="1506"/><summary><person ref="PER1"/> becomes ruler of <location ref="LOC1"/></summary></event><event id="EVE4" type="marriage"><date day="10" month="3" year="1526"/><person ref="PER1"/><person ref="PER2"/><location ref="LOC8"/></event><event id="EVE5" type="birth"><date day="22" month="11" year="1529"/><person ref="PER4"/><parent type="biological" ref="PER1"/><parent type="biological" ref="PER2"/></event><event id="EVE7" type="historical"><date day="28" month="6" year="1519"/><summary><person ref="PER1"/> becomes ruler of the <organisation ref="ORG1"/></summary></event><person id="PER2" year="1530" publish="true"><persona><name xml:lang="en"><name>Isabella</name><origin><particle>of</particle><location>Portugal</location></origin></name><gender>Female</gender></persona></person><person id="PER4" year="1529" publish="true"><persona><name><name>Ferdinand</name></name></persona></person><organisation id="ORG1"><name>Holy Roman Empire</name></organisation><location id="LOC1" type="settlement"><name>Ghent</name><within ref="LOC3"/></location><location id="LOC3" type="country"><name>Belgium</name><within ref="LOC4"/></location><location id="LOC4" type="continent"><name>Europe</name></location><location id="LOC5" type="address"><name>Monastery of Yuste</name><within ref="LOC6"/></location><location id="LOC6" type="settlement"><name>Cuacos de Yuste</name><within ref="LOC7"/></location><location id="LOC7" type="country"><name>Spain</name><within ref="LOC4"/></location><location id="LOC8" type="settlement"><name>Seville</name><within ref="LOC7"/></location></related></person>') 
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};


declare
		
	(: Valid path, valid id :)
	%test:args('person', 'PER1')
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
	%test:args('person', 'PER1')
	%test:assertXPath("$result/view[@path = 'person/PER1']")
	%test:assertXPath("count($result/view/data/person) = 1")
	%test:assertXPath("$result/view/data/person[@id = 'PER1']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
