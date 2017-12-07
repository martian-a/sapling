xquery version "3.0";

import module namespace app-util = "http://ns.thecodeyard.co.uk/xquery/modules/utils" at "../../modules/utils.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "../../modules/local.xq";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $patterns :=
	<patterns>
		<include>*.css</include>
		<exclude />
	</patterns>
return app-util:upload("css", $local:path-to-css, $patterns, "text/css", true())