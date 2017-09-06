xquery version "3.0";

declare variable $exist:path external;
declare variable $exist:controller external;


import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "../modules/config.xq";
import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "../modules/data.xq";

let $params := tokenize(substring-after($exist:path, '/'), '/')
let $media := xs:string($params[1])
let $path := 
	if (xs:string($params[2]) = '') 
	then '/'
	else $params[2]
let $id := xs:string($params[3])
let $graph-direction := 
	if ($media = 'svg') 
	then xs:string($params[4])
	else ''

return
	if ($media = ('html', 'xml', 'svg') and count(data:get-view($path)) = 1) then (
		
		(: An expected media type has been requested and the path is valid :)
		
		if ($id != '') then (
		
			(: An entity view has been requested. :)
			
			let $matches as element()? := data:get-entity($id)
			
			return
			
				if (count($matches) = 1) then (
					
					(: Entity is valid. :)
				
					(: Forward to entity view :)
					<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
				        <forward url="{$exist:controller}/{$media}/index.{$media}">{
				            if (count($matches) = 1)
				            then (
				            	<add-parameter name="id" value="{$id}" />,
				            	<add-parameter name="path" value="{$path}" />,
				           		if ($media = 'svg')
				           		then (
				           			<add-parameter name="graph-direction" value="{$graph-direction}" />
				           		)
				           		else ()
				           	)
				           	else ()
				        }</forward>
				    </dispatch>	
				    
				)
				else (
				
					(: Entity is invalid (but path is valid). :)
					
					(: Redirect to the entity index. :)
					<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
				        <redirect url="{$config:host}{$config:path-to-view}{$media}/{$path}/" />
				    </dispatch>
				
				)
	  
		)
		else (
		
			(: Index is valid  :)
		
			(: Forward to index view :)
			<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
		        <forward url="{$exist:controller}/{$media}/index.{$media}">
	            	<add-parameter name="path" value="{lower-case($path)}" />
		        </forward>
		    </dispatch>
		
		)
		
	)
	else (
		
		(: An unexpected media type or invalid index has been requested.  Redirect to the home page :)
	
		<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
	        <redirect url="{$config:host}{$config:path-to-view}/html/" />
	    </dispatch>
	)