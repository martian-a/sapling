xquery version "3.0";
module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config";

declare variable $config:subject-app-dir := "sapling";
declare variable $config:test-app-dir := "sapling-test";
declare variable $config:host := "http://localhost:8080";

declare variable $config:path-to-subject-app := concat("/db/apps/", $config:subject-app-dir, "/");
declare variable $config:path-to-app := concat("/db/apps/", $config:test-app-dir, "/");
declare variable $config:path-to-app-data := concat($config:path-to-app, "data/");

declare variable $config:path-to-view := concat("/exist/apps/", $config:test-app-dir, "/view/");
declare variable $config:path-to-view-xml := concat($config:path-to-view, "xml/");

declare variable $config:upload-path-to-schemas := concat("/db/apps/", $config:test-app-dir, "/schemas/");
declare variable $config:upload-path-to-view := concat("/db/apps/", $config:test-app-dir, "/view/");
declare variable $config:upload-path-to-css := concat("/db/apps/", $config:test-app-dir, "/css/");
declare variable $config:upload-path-to-xslt := concat("/db/apps/", $config:test-app-dir, "/xslt/");
declare variable $config:upload-path-to-js := concat("/db/apps/", $config:test-app-dir, "/js/");
declare variable $config:upload-path-to-modules := concat("/db/apps/", $config:test-app-dir, "/modules/");

declare variable $config:db := collection($config:path-to-app-data);