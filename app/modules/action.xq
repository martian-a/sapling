xquery version "3.0";
module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action";

import module namespace cred = "http://ns.thecodeyard.co.uk/xquery/settings/credentials" at "cred.xq";
import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";
import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "data.xq";

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
				$parameters-in/param[@name != ('path-to-html', 'path-to-xml')],
				if ($xml/view[@path = '/'])
	    		then (
		    		(: Home Page :)
	    			<param name="path-to-html" value="../html/" />,
	    			<param name="path-to-xml" value="../xml/" />,
	    			<param name="path-to-js" value="../../js/" />,
					<param name="path-to-css" value="../../css/" />,
					<param name="path-to-images" value="../../images/" />
	    		)
	    		else if ($xml/view[@index = 'true'])
	    		then (
	    			(: Index :)
    				<param name="path-to-html" value="../../html/" />,
    				<param name="path-to-xml" value="../../xml/" />,
	    			<param name="path-to-js" value="../../../js/" />,
					<param name="path-to-css" value="../../../css/" />,
					<param name="path-to-images" value="../../../images/" />
	    		)
	    		else (
	    			(: Item View :)
    				<param name="path-to-html" value="../../../html/" />,
    				<param name="path-to-xml" value="../../../xml/" />,
	    			<param name="path-to-js" value="../../../../js/" />,
					<param name="path-to-css" value="../../../../css/" />,
					<param name="path-to-images" value="../../../../images/" />
    			)
			}
		</parameters>
	    	
	return
		if (count($xml) = 0) 
		then ()
		else
			transform:transform($xml, $stylesheet, $parameters) 
	
};