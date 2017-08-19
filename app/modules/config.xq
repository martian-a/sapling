xquery version "3.0";
module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config";

declare variable $config:app-dir := "sapling";
declare variable $config:host := "http://localhost:8080";

declare variable $config:path-to-app := concat("/db/apps/", $config:app-dir, "/");
declare variable $config:path-to-app-data := concat($config:path-to-app, "data/");

declare variable $config:path-to-view := concat("/exist/apps/", $config:app-dir, "/view/");
declare variable $config:path-to-view-xml := concat($config:path-to-view, "xml/");



(:
declare variable $config:upload-path-to-data := concat("/db/apps/", $config:app-dir, "/data/");
declare variable $config:upload-path-to-schemas := concat("/db/apps/", $config:app-dir, "/schemas/");
declare variable $config:upload-path-to-view := concat("/db/apps/", $config:app-dir, "/view/");
declare variable $config:upload-path-to-css := concat("/db/apps/", $config:app-dir, "/css/");
declare variable $config:upload-path-to-xslt := concat("/db/apps/", $config:app-dir, "/xslt/");
declare variable $config:upload-path-to-js := concat("/db/apps/", $config:app-dir, "/js/");
declare variable $config:upload-path-to-modules := concat("/db/apps/", $config:app-dir, "/modules/");
:)

declare variable $config:db := collection($config:path-to-app-data);