function insertGraphControls(optionHasFocus) {
	 
	function createButton(orientation, disabled){
		return '<button class="' + orientation + '" onclick="setGraphOrientation(' + "'" + orientation + "'" + ')"' + ((disabled) ? 'disabled="disabled"' : '')  + ' />';
	};
	
	
	/* Find the container of the graph object */
	var containerNode = document.getElementsByClassName("network-visualisation")[0];
	
	/* Create markup for the controls */
	var controlsNode = document.createElement("div");
	controlsNode.setAttribute("class", "controls");
	var orientationControlsNode = document.createElement("p");
	orientationControlsNode.setAttribute("class", "orientation");
	orientationControlsNode.innerHTML = createButton("portrait", ((optionHasFocus == 'portrait') ? true : false)) + createButton("landscape", ((optionHasFocus == 'landscape') ? true : false));		 
	controlsNode.appendChild(orientationControlsNode);	
	
	/* Append the controls markup to the container */
	containerNode.appendChild(controlsNode);
	
};

function setGraphOrientation(option) {

	/* Check that the option value matches an expected value */
	if (!option.match("portrait|landscape")) {
		return;
	};
	
	/* Find the current graph object */
	var object = document.getElementById('family-tree');
	
	function createReplacement(original) {
	
		/* Clone the original */
		var replacementNode = original.cloneNode(true);

		/* Determine the name of the attribute that specifies the source URL */
		var sourceAttributeName = (replacementNode.nodeName.toLowerCase() == "object") ? "data" : "src";
		
		/* Get the source URL of the clone */
		var dataUrl = replacementNode.getAttribute(sourceAttributeName).toString();
		
		/* Change the source url to reference the orientation option requested */
		function editUrl(url) {
			if (url.indexOf("/landscape/") != -1) {
				url = url.replace("/landscape/", ("/").concat(option, "/"));
			} else {
				url = url.replace("/portrait/", ("/").concat(option, "/"));
			};	
			return url;
		};
		replacementNode.setAttribute(sourceAttributeName, editUrl(dataUrl));
		
		/* Return updated clone */
		return replacementNode;
	};
	
	/* Create a clone of the current graph object and change it's source to reference the orientation option requested */
	var replacementObject = createReplacement(object);
	
	/* Update clone's fallback image (if there is one) */
	if (replacementObject.getElementsByTagName("img").length > 0) {
	
		/* Get the current fallback image */
		var fallbackImage = replacementObject.getElementsByTagName("img")[0];
				
		/* Create a clone of the current fallback image and change it's source to reference the orientation option requested */
		var replacementImage = createReplacement(fallbackImage);
		
		/* Replace the current fallback image with the modified clone */
		replacementObject.replaceChild(replacementImage, fallbackImage);		
	}
	
	/* Replace the current graph object with the modified clone */
	var container = object.parentNode;
	container.replaceChild(replacementObject, object)	
	
	/* Find the orientation controls */							
	var controls = container.getElementsByClassName("controls")[0];
	var controlsPortrait = controls.getElementsByClassName("portrait")[0];
	var controlsLandscape = controls.getElementsByClassName("landscape")[0];
	
	/* Update the controls */
	if (option == "portrait") {
		controlsPortrait.setAttribute("disabled", "disabled");
		controlsLandscape.removeAttribute("disabled");
	} else {
		controlsPortrait.removeAttribute("disabled");
		controlsLandscape.setAttribute("disabled", "disabled");
	};
	
	return;
};