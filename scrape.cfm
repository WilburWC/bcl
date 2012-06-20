<cfsetting enablecfoutputonly="true" showdebugoutput="false" requesttimeout="100000"> 

<cfhttp 
		url="http://phoenix.craigslist.org/search/?areaID=18&subAreaID=&query=xoom&catAbb=sss" 
		method="get" 
		result="variables.sPageLoad">
</cfhttp>

<cfoutput>#variables.sPageLoad.Filecontent#</cfoutput>