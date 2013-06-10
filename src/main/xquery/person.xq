xquery version "1.0";
for $person in doc("/db/apps/sapling/data/people.xml")/people/person[1]
let $id := @id
return
<results>
   <message>{$id}</message>
</results>