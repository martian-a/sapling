xquery version "3.0";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "../modules/config.xq";

declare option exist:serialize "method=xhtml media-type=text/html indent=yes encoding=utf-8";

let $update-modules := 
	let $source-directory := concat($config:path-to-subject-app, "modules/")
	let $target-directory := concat($config:path-to-app, "modules/")
	for $resource in collection($source-directory)[ends-with(util:document-name(.), '.xq')][not(util:document-name(.) = ('config.xq', 'local.xq'))]
    return xmldb:copy($source-directory, $target-directory, $resource/util:document-name(.))

let $update-xslt := 
	let $source-directory := concat($config:path-to-subject-app, "xslt/")
	let $target-directory := $config:path-to-app
	return xmldb:copy($source-directory, $target-directory)

let $update-views := 
	let $source-directory :=  concat($config:path-to-subject-app, "view/")
	let $target-directory := $config:path-to-app
	return xmldb:copy($source-directory, $target-directory)

let $test-modules :=
	let $generic-tests := collection(concat($config:path-to-app, "tests/generic"))[ends-with(util:document-name(.), '.xq')]
	let $custom-tests := collection(concat($config:path-to-app, 'tests/custom'))[ends-with(util:document-name(.), '.xq')]
	return ($generic-tests, $custom-tests)
		
let $parameters := 
		<parameters />

let $stylesheet := doc('style_results.xsl')

let $results :=	test:suite((
	for $module in $test-modules
	let $path-to-test := concat($module/util:collection-name(.), "/", $module/util:document-name(.))
	return inspect:module-functions(xs:anyURI($path-to-test))
))

return transform:transform($results, $stylesheet, $parameters) 
