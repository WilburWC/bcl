<cfscript>
	oParser		=	createObject("component", "craigslist.com.scraper");
	myListings	=	oParser.getListings('http://phoenix.craigslist.org/search/?areaID=18&subAreaID=&query=xoom&catAbb=sss');
	writeOutput(myListings);
</cfscript>