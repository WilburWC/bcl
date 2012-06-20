<cfscript>
	object			=	CreateObject("component","craigslist.sparser.sparser2");
	parser			=	object.init("http://phoenix.craigslist.org/search/?areaID=18&subAreaID=&query=xoom&catAbb=sss");
	
	blocks			=	parser.selector("p.row");
	
	writeDump(blocks);
</cfscript>
