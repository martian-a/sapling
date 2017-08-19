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
	%test:assertEquals('<person id="PER2" year="1500"><persona><name xml:lang="en"><name>Isabella</name><origin><particle>of</particle><location>Portugal</location></origin></name><gender>Female</gender></persona></person>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare

	(: Valid id :)
	%test:args('PER2')
	%test:assertEquals('<result><person id="PER38" year="1800"><persona><name><name>James</name><name family="yes">Girvan</name></name><gender>Male</gender></persona><note><p>Of Berryhill, Auchinleck.</p></note></person><person id="PER39" year="1827"><persona><name><name>William</name><name family="yes">Girvan</name></name><gender>Male</gender></persona><note><p>Farmed 50 acres in North Logan, Sorn, with the assistance of his family and farmhand, Alexander Morton.</p></note></person><person id="PER686" year="1775"><persona><name><name>David</name><name family="yes">Murdoch</name></name><gender>Male</gender></persona><note><p>Of Dalsalloch Farm, Auchinleck.</p></note></person><person id="PER687" year="1775"><persona><name><name>Agnes</name><name family="yes">Dickie</name></name><gender>Female</gender></persona></person><person id="PER688" year="1754"><persona><name><name>Wiliam</name><name family="yes">Murdoch</name></name><gender>Male</gender></persona><note><p>The inventor of gaslight.</p></note></person><person id="PER861" year="1829"><persona><name><name>David</name><name family="yes">Girvan</name></name><gender>Male</gender></persona><note><p>At the age of 71, David was the sole occupant of a dwelling in the "Old Steelwork", Auchenleck, that had only one room with one or more windows. He described himself as being a self-employed "General Dealer" and unmarried.</p></note></person><person id="PER862" year="1824"><persona><name><name>Elizabeth</name><name family="yes">Girvan</name></name><gender>Female</gender></persona></person><person id="PER863" year="1822"><persona><name><name>James</name><name family="yes">Girvan</name></name><gender>Male</gender></persona></person></result>') 

function unit:get-related-people($param) {
	<result>data:get-related-people(data:get-entity($param))</result>
};



declare
			
	(: Valid id :)
	%test:args('PER28')
	%test:assertEquals('<person id="PER28" year="1919"><persona><name><name>Arthur</name><name>James</name><name family="yes">Thomson</name></name><gender>Male</gender></persona><note><p>Served in the <organisation ref="ORG4"/> during World War II. Farmer.</p></note><related><event type="birth" id="EVE46"><date year="1919"/><person ref="PER28"/><parent type="biological" ref="PER67"/><parent type="biological" ref="PER14"/><location ref="LOC7"/></event><event type="death" id="EVE47"><date day="20" month="5" year="1977"/><person ref="PER28"/><location ref="LOC81"/></event><event type="marriage" id="EVE48"><date day="5" month="1" year="1946"/><person ref="PER28"/><person ref="PER42"/><location ref="LOC90"/></event><person id="PER14" year="1880"><persona><name><name>Edward</name><name>Allan</name><name family="yes">Thomson</name></name><gender>Male</gender></persona></person><person id="PER42" year="1907"><persona><name><name>Janet</name><name>Davidson</name><name family="yes">Girvan</name></name><gender>Female</gender></persona></person><person id="PER67" year="1885"><persona><name><name>Jane</name><name>Shaw</name><name family="yes">Blaikley</name></name><gender>Female</gender></persona></person><organisation id="ORG4"><name>Royal Air Force</name></organisation><location id="LOC1" type="continent"><name>Europe</name></location><location id="LOC7" type="country"><name>England</name><within ref="LOC213"/></location><location id="LOC9" type="country"><name>Scotland</name><within ref="LOC213"/></location><location id="LOC19" type="county"><name>Dorset</name><within ref="LOC7"/></location><location id="LOC31" type="county"><name>Perthshire</name><within ref="LOC9"/></location><location id="LOC81" type="settlement"><name>Burton Bradstock</name><within ref="LOC19"/></location><location id="LOC90" type="settlement"><name>Crianlarich</name><within ref="LOC31"/></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC213" type="country"><name>Great Britain</name><within ref="LOC191"/></location></related></person>') 
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
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
