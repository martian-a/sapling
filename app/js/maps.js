function map(id, lat, lon, zoom, markers) {

    var mymap = L.map(id).setView([lat, lon], zoom);
    
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    	attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    	maxZoom: 18,
   		id: 'mapbox.streets',
    	accessToken: accessTokenMapBox
    }).addTo(mymap);
    
    for (i in markers) {

        var marker = L.marker([markers[i][0], markers[i][1]]).addTo(mymap);
        
        // If the marker has a label, add a popup (containing the label) to the marker 
        if(typeof markers[i][2] !== 'undefined') {
            marker.bindPopup(markers[i][2]);
        }
    }
};

