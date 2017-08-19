xquery version "3.0";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";
import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "../modules/config.xq";

let $modules-source-directory := $config:upload-path-to-modules
let $modules-target-directory := $config:upload-path-to-test-modules
let $data-source-directory :=  $config:upload-path-to-data
let $data-target-directory := $config:upload-path-to-test-data
let $include-pattern := "*.xq"
let $exclude-pattern := "config.xq"
let $mime-type := "application/xquery"
let $preserve-structure := true()
let $update-modules := (
	for $resource in collection($modules-source-directory)[ends-with(util:document-name(.), '.xq')][util:document-name(.) != 'config.xq']/util:document-name(.)
    return xmldb:copy($modules-source-directory, $modules-target-directory, $resource),
    for $resource in collection($data-source-directory)[util:document-name(.) = 'app.xml']/util:document-name(.)
    return xmldb:copy($data-source-directory, $data-target-directory, $resource)
)
return 
	test:suite(
		(
	    inspect:module-functions(xs:anyURI("generic/action.xq")),
	    inspect:module-functions(xs:anyURI("generic/data.xq")),
	    inspect:module-functions(xs:anyURI("custom/person.xq")),
	    inspect:module-functions(xs:anyURI("custom/name.xq")),
	    inspect:module-functions(xs:anyURI("custom/location.xq")),
	    inspect:module-functions(xs:anyURI("custom/event.xq")),
	    inspect:module-functions(xs:anyURI("custom/organisation.xq"))
		)
	)