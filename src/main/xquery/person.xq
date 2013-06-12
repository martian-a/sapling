xquery version "1.0";

let $people := doc("/db/apps/sapling/data/people.xml")/people
let $events := doc("/db/apps/sapling/data/events.xml")/events
let $locations := doc("/db/apps/sapling/data/locations.xml")/locations

for $person in $people/person[@id = 'PER78']
let $id := $person/@id
let $related-event-ids := distinct-values($events/event[*[self::person or self::parent]/@ref = $person/@id]/@id)
let $related-events := $events/event[@id = $related-event-ids]
let $related-people-ids := distinct-values($people/person[@id != $id and @id = $related-events/*[self::person or self::parent]/@ref]/@id)
let $related-location-ids := distinct-values($locations//location[@id = $related-events/location/@ref]/@id)
return
    <sapling>
        <person id="{$person/@id}" year="{$person/@year}">               
            {$person/*}
            <related>
            {(            
                $related-events,            
                $people/person[@id = $related-people-ids],
                for $location in $locations//location[@id = $related-location-ids]
                return
                    <location id="{$location/@id}">
                        {$location/name}
                    </location>                
            )}
            </related>
        </person>        
    </sapling>