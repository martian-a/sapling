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
	%test:args('ORG2')
	%test:assertEquals('<organisation id="ORG2"><name>East India Company</name></organisation>') 

function unit:get-entity($param) {
    data:get-entity($param)
};


declare
	
	(: Valid id :)
	%test:args('ORG3')
	%test:assertEquals('<organisation id="ORG3"><name>Glasite Church</name><note><p>The doctrines professed were taken literally from the Scriptures of the Bible and only Psalms were sung. Elders were chosen by the marks given in Timothy 3:1-7 and the law of discipline (Matthew 18:15-17) was strictly observed as a means of preserving peace and unity in the Church. Eating of blood, the use of oaths as between brethren, the use of the lot for frivolous purposes, and the covetous accumulation of riches were all strictly forbidden and members took no part in worship with any not accepting these scriptural doctrines.</p><p>The casting of lots was sacred because after the Crucifixion, lots were cast by the Soldiers for the garments of Christ and all games of chance, gambling, betting, playing cards, etc. were included and strictly forbidden.</p><p>There was also a ban on the eating of meat from animals that did not split the hoof, such as rabbits, and of game that had been shot. These doctrines were closely interpreted but in the course of time that became more moderate. In the early 1880s a split occurred in many of the Churches over differences of interpretation and the groups separated and no longer worshipped together.</p></note><related><event type="historical" id="EVE1404"><date year="1730"/><summary>The <organisation ref="ORG3"/> is founded when John Glas forms his first congregation in <location ref="LOC96"/>.</summary></event><person id="PER10" year="1773"><persona><name><name>John</name><name family="yes">Thomson</name></name><gender>Male</gender></persona></person><location id="LOC1" type="continent"><name>Europe</name></location><location id="LOC9" type="country"><name>Scotland</name><within ref="LOC213"/></location><location id="LOC55" type="county"><name>Angus</name><within ref="LOC9"/></location><location id="LOC96" type="settlement"><name>Dundee</name><within ref="LOC55"/></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC213" type="country"><name>Great Britain</name><within ref="LOC191"/></location></related></organisation>') 
	
function unit:augment-entity($param) {
    data:augment-entity(data:get-entity($param))
};

declare
		
	(: Valid path, valid id :)
	%test:args('organisation', 'ORG2')
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
		
	(: Valid path, no id :) 
	%test:args('organisation', '')
	%test:assertXPath("$result/view[@path = 'organisation']")
	%test:assertXPath("count($result/view/data/entities/organisation) &gt; 1")
				
	(: Valid path, valid id :)
	%test:args('organisation', 'ORG2')
	%test:assertXPath("$result/view[@path = 'organisation/ORG2']")
	%test:assertXPath("count($result/view/data/organisation) = 1")
	%test:assertXPath("$result/view/data/organisation[@id = 'ORG2']")
	
function unit:view-app-xml($param1, $param2) {
    data:view-app-xml($param1, $param2)
};
