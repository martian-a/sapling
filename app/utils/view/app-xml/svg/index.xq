xquery version "3.0";

import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "/db/apps/sapling/modules/data.xq";

declare namespace request="http://exist-db.org/xquery/request";
declare namespace output="http://www.w3.org/2010/xslt-xquery-serialization";

declare option output:method "xml";
declare option output:media-type "text/xml";
declare option output:indent "yes";
declare option output:encoding "utf-8";


let $path := string(request:get-parameter("path", "/"))
let $request-id := string(request:get-parameter("id", ""))
return data:view-app-xml($path, $request-id, true())