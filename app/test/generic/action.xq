xquery version "3.0";
module namespace unit = "http://ns.thecodeyard.co.uk/xquery/test/unit";

import module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action" at "/db/apps/sapling/modules/action.xq";

declare namespace test="http://exist-db.org/xquery/xqsuite";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";


declare
	
	(: No path :)
	%test:args('')
	%test:assertEmpty
	
	(: Valid path :)
	%test:args('index.xml?path=person&amp;id=PER100')
	%test:assertEquals('<person id="PER100" year="1670"><persona><name><name>Josiah</name><name family="yes">Boosy</name></name><gender>Male</gender></persona></person>') 
	
	(: TODO: Invalid path :)
	
function unit:request-xml($param) {
    action:request-xml($param)
};