<cfcomponent>
	
	
	<cffunction name="getListings" access="remote" output="false" returntype="String" returnformat="JSON" hint="I am used to pull just search listings">
		<cfargument name="url" type="string" required="false" default="">
		
		<cfscript>
			var object			=	CreateObject("component","craigslist.sparser.sparser2");
			var parser			=	object.init(Arguments.url);
			var header			=	'';
			var blocks			=	'';
			var i 				=	'';
			var parsedHTML		=	'';
			
			header			=	parser.selector("h4.ban");
			if(header.lastquery.RecordCount)
				{
					parsedHTML  = parsedHTML & header.lastquery.I_TAG_FULL[1] & '<hr>';
				}
				
			blocks			=	parser.selector("p.row");
			if(blocks.lastquery.RecordCount)
				{
					for(i = 1; i LTE blocks.lastquery.RecordCount; i = i + 1)
						{
							parsedHTML  = parsedHTML & blocks.lastquery.I_TAG_FULL[i];
						}
				}
			
		
			return SerializeJSON(parsedHTML);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getDetails" access="remote" output="false" returntype="String" returnformat="JSON" hint="I am used to pull just search listings">
		<cfargument name="url" type="string" required="false" default="">
		
		<cfscript>
			var object			=	CreateObject("component","craigslist.sparser.sparser2");
			var parser			=	object.init(Arguments.url);
			var header 			=	"";
			var blocks			=	"";
			var i 				=	'';
			var parsedHTML		=	'';
			
			header 			=	parser.selector("h2");
			if(header.lastquery.RecordCount)
				{
					parsedHTML  = parsedHTML & header.lastquery.I_TAG_FULL;
				}
			blocks			=	parser.selector("##userbody");	
			if(blocks.lastquery.RecordCount)
				{
					for(i = 1; i LTE blocks.lastquery.RecordCount; i = i + 1)
						{
							parsedHTML  = parsedHTML & blocks.lastquery.I_TAG_FULL[i];
						}
				}
			
		
			return SerializeJSON(parsedHTML);
		</cfscript>
		
	</cffunction>
	
	<cffunction name="getCities" access="remote" output="false" returntype="String" returnformat="JSON" hint="">
		<cfargument name="url" type="string" required="false" default="">
		
		<cfscript>
			var object			=	CreateObject("component","craigslist.sparser.sparser2");
			var parser			=	object.init(Arguments.url);
			var blocks			=	parser.selector("p.row");
			var i 				=	'';
			var parsedHTML		=	'';
			
			if(blocks.lastquery.RecordCount)
				{
					for(i = 1; i LTE blocks.lastquery.RecordCount; i = i + 1)
						{
							parsedHTML  = parsedHTML & blocks.lastquery.I_TAG_FULL[i];
						}
				}
		
			return SerializeJSON(parsedHTML);
		</cfscript>
		
	</cffunction>
</cfcomponent>