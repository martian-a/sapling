xquery version "3.0";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "/db/apps/sapling/modules/config.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "/db/apps/sapling/modules/local.xq";

declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

<results>{
    let $collection := $config:upload-path-to-xslt
    let $directory := $local:path-to-xslt
    let $pattern := "*.xsl"
    let $mime-type := "application/xslt+xml"
    return 
        <request>
            <collection>{$collection}</collection>
            <directory>{$directory}</directory>
            <pattern>{$pattern}</pattern>
            <mime-type>{$mime-type}</mime-type>
            <uploaded>{
                for $file in xmldb:store-files-from-pattern(
                    $collection, 
                    $directory, 
                    $pattern, 
                    $mime-type
                )
                return
                    <file>{$file}</file>
            }</uploaded>
     </request>
}</results>
    