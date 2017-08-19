xquery version "3.0";

import module namespace app-util = "http://ns.thecodeyard.co.uk/xquery/modules/utils" at "../../modules/utils.xq";
import module namespace local = "http://ns.thecodeyard.co.uk/xquery/settings/local" at "../../modules/local.xq";

declare option exist:serialize "method=xml media-type=text/xml indent=yes";

app-util:upload("view", $local:path-to-view, "controller.xql", "application/xquery", false())/*
    