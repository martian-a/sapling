xquery version "3.0";

import module namespace action = "http://ns.thecodeyard.co.uk/xquery/modules/action" at "../../modules/action.xq";

declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xml media-type=application/javascript indent=no encoding=utf-8";


let $path := string(request:get-parameter("path", "/"))
let $request-id := string(request:get-parameter("id", ""))

let $parameters := 
	<parameters />

return action:request-js($path, $request-id, $parameters)