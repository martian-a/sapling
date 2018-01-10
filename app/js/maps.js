function map(id, lat, lon, zoom) {

    var mymap = L.map(id).setView([lat, lon], zoom);
    
    L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
    	attribution: 'Map data © <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
    	maxZoom: 18,
   		id: 'mapbox.streets',
    	accessToken: accessTokenMapBox
    }).addTo(mymap);
        
    var marker = L.marker([lat, lon]).addTo(mymap);

};

