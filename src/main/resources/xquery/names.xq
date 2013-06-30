xquery version "1.0";

let $people := doc("/db/apps/sapling/data/people.xml")/people
let $locations := doc("/db/apps/sapling/data/locations.xml")/locations

let $names-people := $people/person/persona/name/name
let $names-locations := $locations/descendant::location/name

return
    <sapling>
        <names>               
            {(
                $names-people,
                $names-locations
            )}
        </names>        
    </sapling>