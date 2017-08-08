xquery version "3.0";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "/db/apps/sapling/modules/config.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "/db/apps/sapling/modules/local.xq";

declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

let $target-collection := $config:upload-path-to-data
let $source-directory := $local:path-to-data
let $pattern := "*.xml"
let $mime-type := "text/xml"
let $preserve-structure := false()
return 
	<results>{
	        <request>
	            <collection>{$target-collection}</collection>
	            <directory>{$source-directory}</directory>
	            <pattern>{$pattern}</pattern>
	            <mime-type>{$mime-type}</mime-type>
	            <uploaded>{
	                for $file in xmldb:store-files-from-pattern(
	                    $target-collection, 
	                    $source-directory, 
	                    $pattern, 
	                    $mime-type,
	                    $preserve-structure
	                )
	                return
	                    <file>{$file}</file>
	            }</uploaded>
	     </request>
	}</results>
	    