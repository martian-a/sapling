xquery version "1.0";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace xs="http://www.w3.org/2001/XMLSchema";

let $id := request:get-parameter("id",'')
let $people := collection("/db/apps/sapling-test/data")/people
let $events := collection("/db/apps/sapling-test/data")/events
let $locations := collection("/db/apps/sapling-test/data")/locations

return
    <sapling>
    	{
    		for $event in $events/event[@id = $id]
    		let $related-people := $event/*[self::person or self::parent]
    		let $related-locations := $locations//(location[@id = $event/location/@ref] | location[@id = $event/location/@ref]/ancestor::location[type = 'Country'][1])
			let $related-people-ids := distinct-values($related-people/@ref)
			let $related-location-ids := distinct-values($related-locations/@id)
			return
        		<event id="{$event/@id}" type="{$event/@type}">               
            		{$event/*}
            		<related>
		                <people>
		                    {
		                        for $related-person in $people/person[@id = $related-people-ids]
		                        order by xs:integer(substring-after($related-person/@id, 'PER')) ascending
		                        return $related-person                        
		                    }
		                </people>
		                <locations>
		                    {
		                        (:
		                        for $location in $locations//location[@id = $related-location-ids]
		                        order by $location/count(ancestor::*) ascending
		                        return
		                            <location id="{$location/@id}">
		                                {$location/name}
		                            </location>
		                        :)		       
                                for $country in $locations//location[@id = $event/location/@ref]/ancestor::location[type = 'Country'][1]		                        
		                        return 
    		                        <location id="{$country/@id}">
    		                            {$country/name}
                                        {
    		                                for $birth-place in $locations//location[@id = $event/location/@ref]
    		                                return
    		                                    <location id="{$birth-place/@id}">
    		                                        {$birth-place/name}
    		                                    </location>    		                                    
    		                            }
    		                        </location>	
		                    }
		                </locations>
		            </related>
		        </event>        
		}
    </sapling>