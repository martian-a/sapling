xquery version "3.0";
module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action";

import module namespace cred = "http://ns.thecodeyard.co.uk/xquery/settings/credentials" at "cred.xq";
import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";
import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "data.xq";
import module namespace gv = "http://kitwallace.co.uk/ns/graphviz" at "../../graphviz/lib/graphviz.xqm";



declare namespace httpclient="http://exist-db.org/xquery/httpclient";


(: Make HTTP request :)
declare function action:request-http($uri as xs:anyURI) as item() {
  let $credentials := concat($cred:username,":",$cred:password)
  let $credentials := util:string-to-binary($credentials)
  let $headers  := 
    <headers>
      <header name="Authorization" value="Basic {$credentials}"/>
    </headers>
  return httpclient:get(xs:anyURI($uri),false(), $headers)
};


(: Get XML view :)
declare function action:request-xml($path as xs:string?) as item()* {
	if ($path = '')
	then ()
	else
	    let $uri := xs:anyURI(concat($config:host, $config:path-to-view-xml, $path))
	    let $response := action:request-http($uri)
	    return $response/httpclient:body/*
};




(: Build HTML view (no parameters) :)
declare function action:request-html($path as xs:string?, $id as xs:string?) as item()? {
	action:request-html($path, $id, ())
};

(: Build HTML view :)
declare function action:request-html($path-in as xs:string?, $id-in as xs:string?, $parameters-in as element()?) as item()? {

	let $xml := data:view-app-xml($path-in, $id-in)
	   
	let $stylesheet := doc(concat($config:upload-path-to-xslt, "global.xsl"))    
	
	let $parameters := 
		<parameters>
			{
				$parameters-in/param[@name != ('path-to-view-html', 'path-to-view-xml', 'path-to-view-svg')],
				if ($xml/view[@path = '/'])
	    		then (
		    		(: Home Page :)
	    			<param name="path-to-view-html" value="../html/" />,
	    			<param name="path-to-view-xml" value="../xml/" />,
	    			<param name="path-to-view-svg" value="../svg/" />,
	    			<param name="path-to-js" value="../../js/" />,
					<param name="path-to-css" value="../../css/" />,
					<param name="path-to-images" value="../../images/" />
	    		)
	    		else if ($xml/view[@index = 'true'])
	    		then (
	    			(: Index :)
    				<param name="path-to-view-html" value="../../html/" />,
    				<param name="path-to-view-xml" value="../../xml/" />,
    				<param name="path-to-view-svg" value="../../svg/" />,
	    			<param name="path-to-js" value="../../../js/" />,
					<param name="path-to-css" value="../../../css/" />,
					<param name="path-to-images" value="../../../images/" />
	    		)
	    		else (
	    			(: Item View :)
    				<param name="path-to-view-html" value="../../../html/" />,
    				<param name="path-to-view-xml" value="../../../xml/" />,
    				<param name="path-to-view-svg" value="../../../svg/" />,
	    			<param name="path-to-js" value="../../../../js/" />,
					<param name="path-to-css" value="../../../../css/" />,
					<param name="path-to-images" value="../../../../images/" />
    			)
			}
		</parameters>
	    	
	return
		if (count($xml) = 0) 
		then ()
		else transform:transform($xml, $stylesheet, $parameters) 
	
};


(: Build script view :)
declare function action:request-svg($path-in as xs:string?, $id-in as xs:string?, $parameters-in as element()?) as item()* {

	let $xml := data:view-app-xml($path-in, $id-in, true())
	   
	let $stylesheet := doc(concat($config:upload-path-to-xslt, "visualisations/family_tree.xsl"))    
	
	let $parameters := 
		<parameters>
			<param name="serialise" value="dot" />
			{
				$parameters-in/param[@name != ('path-to-view-html', 'path-to-view-xml', 'path-to-view-svg')],
				if ($xml/view[@path = '/'])
	    		then (
		    		(: Home Page :)
	    			<param name="path-to-view-html" value="../html/" />,
	    			<param name="path-to-view-xml" value="../xml/" />,
	    			<param name="path-to-view-svg" value="../svg/" />,
	    			<param name="path-to-js" value="../../js/" />,
					<param name="path-to-css" value="../../css/" />,
					<param name="path-to-images" value="../../images/" />
	    		)
	    		else if ($xml/view[@index = 'true'])
	    		then (
	    			(: Index :)
    				<param name="path-to-view-html" value="../../html/" />,
    				<param name="path-to-view-xml" value="../../xml/" />,
    				<param name="path-to-view-svg" value="../../svg/" />,
	    			<param name="path-to-js" value="../../../js/" />,
					<param name="path-to-css" value="../../../css/" />,
					<param name="path-to-images" value="../../../images/" />
	    		)
	    		else (
	    			(: Item View :)
    				<param name="path-to-view-html" value="../../../../html/" />,
    				<param name="path-to-view-xml" value="../../../../xml/" />,
    				<param name="path-to-view-svg" value="../../../../svg/" />,
	    			<param name="path-to-js" value="../../../../../js/" />,
					<param name="path-to-css" value="../../../../../css/" />,
					<param name="path-to-images" value="../../../../../images/" />
    			)
			}
		</parameters>
	    	
	return
		if (count($xml) = 0) 
		then ()
		else 
			let $dot := transform:transform($xml, $stylesheet, $parameters)
			(: If this fails, check directory settings in graphviz module config :)
			return gv:dot-to-svg($dot)
			
	
};