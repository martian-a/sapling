xquery version "3.0";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

declare namespace request="http://exist-db.org/xquery/request";

declare option exist:serialize "method=xml media-type=text/xml indent=yes encoding=utf-8";

let $path := string(request:get-parameter("path", "/"))
let $request-id := string(request:get-parameter("id", ""))
return data:view-app-xml($path, $request-id)