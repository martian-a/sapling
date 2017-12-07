xquery version "3.0";
module namespace app-util = "http://ns.thecodeyard.co.uk/xquery/modules/utils";

import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";

declare function app-util:upload($target-collection-name as xs:string, $source-directory as xs:string, $patterns as element(), $mime-type as xs:string) as item() {
	app-util:upload($target-collection-name, $source-directory, $patterns, $mime-type, false())
};


(: Upload resources into the app :)
declare function app-util:upload($target-collection-name as xs:string, $source-directory as xs:string, $patterns as element(), $mime-type as xs:string, $preserve-structure as xs:boolean) as item() {
		
	<results>{
		let $target-collection := xmldb:create-collection($config:path-to-app, $target-collection-name)
		return 
	        <request>
	            <collection>{$target-collection}</collection>
	            <directory>{$source-directory}</directory>
	            {$patterns}
	            <mime-type>{$mime-type}</mime-type>
	            <uploaded>{
	                for $file in xmldb:store-files-from-pattern(
	                    $target-collection, 
	                    $source-directory, 
	                    $patterns/include/xs:string(.), 
	                    $mime-type,
	                    $preserve-structure,
	                    $patterns/exclude/xs:string(.)
	                )
	                return
	                    <file>{$file}</file>
	            }</uploaded>
	     </request>
	}</results>

};
