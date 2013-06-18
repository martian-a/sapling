xquery version "1.0";

let $people := collection("/db/apps/sapling-test/data")/people
let $events := collection("/db/apps/sapling-test/data")/events
let $locations := collection("/db/apps/sapling-test/data")/locations

let $fragment-1 :=
    <sapling>
        <people>      
            {
                for $person in $people/person
                let $id := $person/@id
                order by xs:integer(substring-after($person/@id, 'PER')) ascending
                return
                    <person id="{$person/@id}" year="{$person/@year}">               
                        {$person/persona}                
                    </person>
            }
        </people>   
        <events>
            {
                for $event in $events/event[@type = ('birth', 'christening', 'death')]
                order by xs:integer(substring-after($event/@id, 'EVE')) ascending
                return $event
            }
        </events>
    </sapling>
    
let $related-location-ids := distinct-values($fragment-1//location/@ref)    
    
let $related-locations :=
    <sapling>
        <locations>
            {
                for $location in $locations//location
                where $location/@id = $related-location-ids
                order by xs:integer(substring-after($location/@id, 'LOC')) ascending
                return
                    <location id="{$location/@id}">
                        {$location/name}
                    </location>
            }
        </locations>
    </sapling>
    
return
    <sapling>
        {
            $fragment-1/people,
            $fragment-1/events,
            $related-locations/locations
        }
    </sapling>