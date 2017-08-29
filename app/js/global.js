jQuery(document).ready(function($) {
	
	var pageClass = $("html").attr("class");

	/* 
	 * Insert containers for javascript dependent visualisations
	 */
	if (pageClass == "person") {
		if ($("#network-graph").length == 0) {
			$("div.family > div").filter(":last").after("<div class=\"network-graph\"><h3 id=\"network-graph\">Network Graph</h3><div id=\"vis1\" class=\"network-visualisation\"/></div>");
		}	
	};
	
	generateVisualisations($);
	
});