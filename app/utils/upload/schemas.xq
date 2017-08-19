xquery version "3.0";

import module namespace app-util = "http://ns.thecodeyard.co.uk/xquery/modules/utils" at "../../modules/utils.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "../../modules/local.xq";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

<results>{
    for $schema-type in ('rnc', 'sch')
	let $patterns := 
		<patterns>
			<include>{concat("**/*.", $schema-type)}</include>
			<exclude />
		</patterns>
	let $mime-type := if ($schema-type = 'rnc') then "text/plain" else "text/xml"
    return app-util:upload("schemas", $local:path-to-schemas, $patterns, $mime-type, true())/*
}</results>