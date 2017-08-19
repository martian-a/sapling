xquery version "3.0";

import module namespace app-util = "http://ns.thecodeyard.co.uk/xquery/modules/utils" at "../../modules/utils.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "../../modules/local.xq";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

<results>{
	app-util:upload("view/", $local:path-to-view, <patterns><include>controller.xql</include><exclude>*.xml</exclude></patterns>, "application/xquery", false())/*,
    for $view in ('xml', 'html')
    let $target-collection-name := concat("view/", $view)
    let $source-directory := concat($local:path-to-view, $view)
    let $patterns := 
		<patterns>
			<include>{concat("*.", $view)}</include>
			<exclude />
		</patterns>
    let $mime-type := "application/xquery"
    return app-util:upload($target-collection-name, $source-directory, $patterns, $mime-type, true())/*
}</results>
    