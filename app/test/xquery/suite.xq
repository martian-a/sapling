xquery version "3.0";

import module namespace test="http://exist-db.org/xquery/xqsuite" at "resource:org/exist/xquery/lib/xqsuite/xqsuite.xql";

test:suite(
	(
    inspect:module-functions(xs:anyURI("generic/action.xq")),
    inspect:module-functions(xs:anyURI("generic/data.xq")),
    inspect:module-functions(xs:anyURI("custom/person.xq")),
    inspect:module-functions(xs:anyURI("custom/name.xq")),
    inspect:module-functions(xs:anyURI("custom/location.xq")),
    inspect:module-functions(xs:anyURI("custom/event.xq"))
	)
)