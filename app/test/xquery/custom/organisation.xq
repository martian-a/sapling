xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit/data/organisation";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

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
	%test:args('ORG2')
	%test:assertEquals('<organisation id="ORG2"><name>East India Company</name><related><event type="historical" id="EVE1159"><date day="31" month="12" year="1600"/><location ref="LOC191"/><summary>The <organisation ref="ORG2"/> is founded.</summary></event><event type="historical" id="EVE1171"><date year="1686"/><location ref="LOC23"/><summary>The <organisation ref="ORG2"/> goes to war with the Mughal Empire.</summary></event><event type="historical" id="EVE1173"><date day="23" month="6" year="1757"/><summary>The <organisation ref="ORG2"/> defeats Mughal and French forces at <location ref="LOC211"/>.</summary></event><event type="historical" id="EVE1199"><date day="4" month="5" year="1799"/><location ref="LOC234"/><summary>Tipu Sultan is defeated and killed by the forces of the <organisation ref="ORG2"/>, increasing their influence in South India.</summary></event><event type="historical" id="EVE1212"><date year="1819"/><summary>The <organisation ref="ORG2"/> buys <location ref="LOC230"/>.</summary></event><event type="historical" id="EVE1213"><date day="24" month="2" year="1826"/><location ref="LOC247"/><summary><location ref="LOC246"/> signs a treaty ceding control over <location ref="LOC248"/> and <location ref="LOC249"/> to the <organisation ref="ORG2"/>.</summary></event><event type="historical" id="EVE1214"><date year="1830"/><summary>The <organisation ref="ORG2"/> takes <location ref="LOC245"/>.</summary></event><event type="historical" id="EVE1400"><date year="1682"/><location ref="LOC23"/><summary>The <organisation ref="ORG2"/> seeks permission from the Mughal Empire for regular trading privileges throughout the Mughal Empire.  The application is refused.</summary></event><event type="historical" id="EVE1401"><date day="16" month="8" year="1687"/><location ref="LOC23"/><summary>The <organisation ref="ORG2"/> and the Mughal Empire agree a peace treaty.</summary></event><event type="historical" id="EVE1403"><date year="1757"/><preceded-by ref="EVE1173"/><summary>The <organisation ref="ORG2"/> begins rebuilding <location ref="LOC82"/>.</summary></event><organisation id="ORG2"><name>East India Company</name></organisation><location id="LOC1" type="continent"><name>Europe</name></location><location id="LOC3" type="continent"><name>Asia</name></location><location id="LOC13" type="country"><name>India</name><within ref="LOC3"/></location><location id="LOC23" type="region"><name>Bengal</name><within ref="LOC13"/></location><location id="LOC82" type="settlement"><name>Kolkata</name><within ref="LOC209"/><note><p>Also known as Calcutta.</p></note></location><location id="LOC191" type="country"><name>United Kingdom</name><within ref="LOC1"/></location><location id="LOC209" type="state"><name>West Bengal</name><within ref="LOC23"/></location><location id="LOC211" type="settlement"><name>Palashi</name><within ref="LOC209"/><note><p>Also known as Plassey.</p></note></location><location id="LOC230" type="country"><name>Singapore</name><within ref="LOC3"/></location><location id="LOC232" type="state"><name>Karnataka</name><within ref="LOC23"/></location><location id="LOC234" type="settlement"><name>Srirangapatnam</name><within ref="LOC232"/><note><p>Also known as Seringapatnam.</p></note></location><location id="LOC244" type="state"><name>Karnataka</name><within ref="LOC23"/></location><location id="LOC245" type="settlement"><name>Mysuru</name><within ref="LOC244"/><note><p>Also known as Mysore.</p></note></location><location id="LOC246" type="country"><name>Myanmar</name><within ref="LOC3"/><note><p>Also known as Burma.</p></note></location><location id="LOC247" type="settlement"><name>Yandabo</name><within ref="LOC246"/></location><location id="LOC248" type="state"><name>Assam</name><within ref="LOC23"/></location><location id="LOC249" type="state"><name>Manipur</name><within ref="LOC23"/></location></related></organisation>') 
	
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
