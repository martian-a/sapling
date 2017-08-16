xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/person";

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
	%test:args('PER52')
	%test:assertEquals('<person id="PER52" year="1791"><persona><name><name>John</name><name family="yes">Allen</name></name><gender>Male</gender></persona><note><p>John Allen was born in Ulster where his family had settled after leaving Ayrshire, in Scotland, during the Stuart religious persecutions. </p><p>In the eighteenth century spellings of family names were not firmly fixed and it has been claimed that John&apos;s surname was in fact spelt Allan, however this seems unlikely as his brother James also spelt his name Allen.</p><p>John served as a seaman in the British Navy, from 1800 until 1815. He served during the Peninsular War (1808-14), a Napoleonic war, and was present at the Battle of Corunna, in 1809, when the British Army had to be evacuated from Spain. He was taken prisoner by the French and suffered great hardships until exchanged two years later.</p><p>In 1815 John took discharge from the Abouker and settled in Kilmarnock.</p><p>During the late 18th and early 19th centuries, Scottish society in the Highlands suffered severely from the collapse of its system of chiefs and fighting clans. As the population increased, overcrowding occurred and subsistence farming did not meet food needs. In order to create space for sheep farming many major landowners evicted crofters, sometimes burning their cottages.</p><p>The Allans were weavers and small farmers and in 1842 John and Agnes emigrated to New Zealand with their four sons and three daughters. </p><p>They were not simply seeking to escape the poverty and tense political situation; another reason for leaving was to found a church in which they could worship, in their own way, without interference. The Allans were religious dissenters and had attended the Burgher Kirk, in Kilmarnock, one of many sects that split from the Church of Scotland during the 18th century.</p><p>The voyage, aboard the sailing ship New Zealand, lasted 123 days. They settled in Nelson but owing to difficulties over land tenure and with Maoris, moved to Dunedin in 1848 when the Otago settlement was formed.</p><p>John attended the East Taieri Presbyterian Church, of which he became the first Elder, and in 1854 the first Presbyter for Otago Province. He was a deeply religious man with strong views and it is related of him that at one period he did not got to church for 18 months because of some statement from the pulpit, a difference of opinion that was happily resolved.</p></note><related><event type="historical" id="EVE1200"><date year="1800"/><summary><person ref="PER52"/> runs away to sea (aged 9).</summary></event><event type="marriage" id="EVE91"><date year="1820"/><person ref="PER52"/><person ref="PER53"/><location ref="LOC120"/></event><event type="death" id="EVE90"><date year="1863"/><person ref="PER52"/><location ref="LOC12"/></event><event type="birth" id="EVE89"><date year="1791"/><person ref="PER52"/><location ref="LOC10"/></event><event type="birth" id="EVE213"><date year="1828"/><person ref="PER126"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="birth" id="EVE211"><date year="1833"/><person ref="PER125"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="birth" id="EVE209"><date year="1826"/><person ref="PER124"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="birth" id="EVE207"><date year="1821"/><person ref="PER123"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="birth" id="EVE204"><date year="1837"/><person ref="PER122"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="birth" id="EVE201"><date year="1831"/><person ref="PER121"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC9"/></event><event type="historical" id="EVE1225"><date year="1842"/><summary><person ref="PER53"/> and <person ref="PER52"/> emigrate to <location ref="LOC12"/>.</summary></event><event type="historical" id="EVE1203"><date year="1809"/><summary><person ref="PER52"/> is captured by Napolean Bonaparte&apos;s forces during the Battle of Corunna.</summary></event><event type="birth" id="EVE94"><date year="1824"/><person ref="PER54"/><parent type="biological" ref="PER53"/><parent type="biological" ref="PER52"/><location ref="LOC120"/></event><person id="PER52" year="1791"><persona><name><name>John</name><name family="yes">Allen</name></name><gender>Male</gender></persona></person><person id="PER53" year="1794"><persona><name><name>Agnes</name><name family="yes">Allan</name></name><gender>Female</gender></persona></person><person id="PER54" year="1824"><persona><name><name>James</name><name family="yes">Allan</name></name><gender>Male</gender></persona></person><person id="PER121" year="1831"><persona><name><name>John</name><name family="yes">Allan</name></name><gender>Male</gender></persona></person><person id="PER122" year="1837"><persona><name><name>William</name><name>Brown</name><name family="yes">Allan</name></name><gender>Male</gender></persona></person><person id="PER123" year="1821"><persona><name><name>Janet</name><name family="yes">Allan</name></name><gender>Female</gender></persona></person><person id="PER124" year="1826"><persona><name><name>Isabella</name><name family="yes">Allan</name></name><gender>Female</gender></persona></person><person id="PER125" year="1833"><persona><name><name>Agnes</name><name family="yes">Allan</name></name><gender>Female</gender></persona></person><person id="PER126" year="1828"><persona><name><name>Joseph</name><name family="yes">Allan</name></name><gender>Male</gender></persona></person><location id="LOC1" type="continent"><name>Europe</name></location><location id="LOC6" type="continent"><name>Oceania</name></location><location id="LOC9" type="country"><name>Scotland</name><within ref="LOC213"/></location><location id="LOC27" type="county"><name>Ayrshire</name><within ref="LOC9"/></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC213" type="country"><name>Great Britain</name><within ref="LOC191"/></location></related></person>') 
	
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
