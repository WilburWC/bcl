<!---
Name             : Jericho Helper Parser
Author           : Pablo Schaffner - pablo@creador.cl 
Created          : December 4, 2010
History          : December 11, 2010	: Added methods selector and filter, for jQuery style element selector and filtering.
				 : December 12, 2010	: Added support for (multiple) attribute filtering in selector.
				 : December 13, 2010	: Added support for text source on method Init. Improved speed on method setSource.
				 : December 14, 2010	: Now supports unlimited parent child selectors.. much more powerful.
				 : December 15, 2010	: Added support for cache. Requires either Open Bluedragon or cf_accelerate custom tag.
				 : December 16, 2010	: Improved speed parsing 20 times, by parsing tags at Init.
				 : December 17, 2010	: Added filters :first-child, :neq(x). Fixed filter parsing when using multiple parent child statements.
				 						: Improved getAllTags so to not execute a complete parsing everytime.
										: Added filters :checkbox, :checked, :disabled, :enabled, :empty.
				 : December 18, 2010	: Improved filter :empty for input tags with value attribute.
				 						: Appended prefix '_' char to tag attributes that are reserved words in SQL (only for query types). So column 'value' is now '_value'.
										: Fixed some bad behaviour of filter :first-child.
										: Added filters :input, :last-child, :nth-child(even), :nth-child(odd), :nth-child(position), :parent.
										: Replaced ListContainsNoCase functions with ListFindNoCase neq 0. Its much faster and precise.
										: NOTE: As opposed to jQuery all positions in this parser are 1 based instead of 0.
										: Component named changed from parser.cfc to sparser2.cfc due to an error with Googlecode SVN.
										: Added filter :only-child.
				 : December 19, 2010	: Added filter :selected.
				 						: Added method .parents(), .parents(x).
										: If you dont query reserved SQL words in attributes with the _ prefix, its now added automatically for you.
										: Added methods: parents(), parents(x), parent(), parent(x), closest(x).
										: Corrected filter method. Now supports any selector as argument.
				 : December 20, 2010	: Added method .html(), .html(x).
				 						  Added support for JavaLoader when appengine is not BlueDragon. So its easier to just unpack and use.
										  Added method .replaceWith(x).
										  Fixed class selector search (selector(".class")). Now found selectors can also include other classes as well. Original CSS selector syntax.
										  Added support for statement type selector("tag#id").
										  Added method .text(), .text(x).
				 : May 23, 2011			: Revision.
				 : Aug 1, 2011			: Adobe Coldfusion compatible version.
				 : Aug 19, 2011			: Escaped 'null' tags attribute name.
				 : Dec 12, 2011			: Renamed attributes starting with a _ char to i_. (Sean Hynes found Bug Nº2)
				 : January 8, 2012		: Fixed support for using reserved characters inside selector's escaping them with a backslash character.
				 						  Example: parser.selector("a[class=auction\ url]")
										  returns all links that have a class with a value of "auction url". Thanks to Sean Hynes for spotting this need!
				 : March 6, 2012		: Added findSelector(type,value) method, for finding selectors using values (uses the current url or content given).
Methods:
<cfset object=CreateObject("component","base.apis.sparser2")>

parser = object.Init("http://www.creador.cl/index2.cfm")							=	Extracts the URI contents to process. Can also be a local file or a string with tags.
parser = object.Init("http://www.creador.cl/index2.cfm",CreateTimeSpan(0,0,5,0))	=	Extracts the URI contents to process every 5 minutes or use cached copy.
parser.getTitle()																	=	Returns the document title
parser.getEncoding()																=	Returns the document encoding (charset)
parser.format()																		=	Indents the current code.
parser.format("   ")																=	Indents the current code with the given string.
parser.format("   ",true)															=	Indents all tags in current code with the given string.
parser.compress()																	=	Returns the current code compressed.
parser.setCaseSensitive(false)														=	Disables case sensitive statement matches for selector.
parser.registerTag("wmlmarkup","wml,card,anchor,do,option,postfield,prev",false)	=	(call it before getAllTags or Selector) Register your own tagtypes.
parser.getContent()																	=	Returns the current source content. Very useful to retreive it after DOM manipulation.

Content Processing Methods:
-------------------------------
Option A: (supports prefixes)
parser.getAllTags()							=	Returns an Array of Structures with all tags and attributes in current content.
parser.getAllTags("p")						=	Returns an Array of Structures with all P tags and attributes in current content.
parser.getAllTags("p",true)					=	Return a Query with all P tags and defined attributes in current content.

Option B: (no prefixes)
parser.selector("p")						=	Creates a query with all P tags and defined attributes and returns a this object.
parser.selector("p").query()				=	Returns a query with all P tags and defined attributes.
parser.selector("p").query(where)			=	(helper mode) Returns a query with all P tags and defined attributes matching the aditional where statement.
parser.selector("p").sql()					=	Returns an Array of Structures with all SQL statements executed to retreive the P tag.
parser.selector("p").time()					=	Time it took to process selector in ms.

Selector Methods (to be applied after any selector):
selector("p").parent()						=	Retreive the first parent element tag of each record of last selector query.
selector("p").parent(x)						=	Retreive the first parent element tag that match the 'x' selector of each record of last selector query.
selector("p").parents()						=	Get the ancestors of each element in the current set of matched elements.
selector("p").parents(x)					=	Get the ancestors of each element in the current set of matched elements filtered by a selector.
selector("p").closest(x)					=	Retreive the closest match given the 'x' selector of a parent tag for the last selector query.
selector("p").filter(":filter")				=	Apply the given filter to the last selector query.
selector("p").html()						=	Returns the first selector result content.
selector("p").html(x)						=	Replaces all instances of the selector content with the given argument (x). (The first method to manipulate the DOM).
selector("p").replaceWith(x)				=	Replaces each instances of the matched elements with the given content.
selector("p").text()						=	Get the combined text contents of each element in the set of matched elements, including their descendants.
selector("p").text(x)						=	Set the content of each element in the set of matched elements to the specified text.

"p" is a Statement of CSS selector type (based on jQuery syntax).
Multiple statements can be defined using a comma delimiter. (3 maximum)
So the following can be inside selector value:

statements:
selector("*")								=	Searches for all existing tags.
selector("tag")								=	Searches for the given tag, and returns all existing attributes.
selector(".class")							=	Searches all tags that have the given 'class' name.
selector("#id")								=	Searches all tags that have the given 'id' value.
selector("tag.class")						=	Searches for the given tag that have the given 'class' name.
selector("tag#id")							=	Searches for the given tag that have the given 'id' value.
selector("tag#id.class")					=	Searches for the given tag that have the given 'id' value and the given 'class' name.
selector(":filter")							=	You can also apply filters even without specifying a previous statement.

you can apply filters... (tag below can be any of the previous statements.. ex: selector(".class:even") works.. )

selector("tag:even")				=	Returns only the even results for the searched 'tag' name.
selector("tag:odd")					=	Returns only the odd results for the searched 'tag' name.
selector("tag:eq(n)")				=	Returns only the 'n' positioned element for the searched 'tag' name.
selector("tag:neq(n)")				=	Returns all elements excepto those positioned at the 'n' element for the searched 'tag' name.
selector("tag:gt(n)")				=	Returns only the elements positioned after 'n' for the searched 'tag' name.
selector("tag:lt(n)")				=	Returns only the elements positioned before 'n' for the searched 'tag' name.
selector("tag:not(statement)")		=	Returns only tags that are not included in the 'selector' statement (the value there can be any selector statement..)***NOT WORKING***
selector("tag:first")				=	Returns the first result of the statement.
selector("tag:first-child")			=	Returns the first element of each child element of the previous statement.
selector("tag:contains(x)")			=	Returns only tags that contains the given text.
selector("tag:header")				=	Returns all headers contained in the given statement or tag.
selector("tag:button")				=	Returns all button tags or type button elements in the given statement.
selector("tag:checkbox")			=	Returns all elements that are of type="checkbox" (within the given statement, as all others).
selector("tag:checked")				=	Returns all elements that have attribute checked with value checked. All checked elements.
selector("tag:selected")			=	Returns all elements that have attribute selected with value selected. All selected elements.
selector("tag:disabled")			=	Returns all elements that have attribute disabled with value disabled. All disabled elements.
selector("tag:enabled")				=	Returns all enabled elements (meaning not being disabled).
selector("tag:empty")				=	Returns all empty elements. Select all elements that have no children (including text nodes).
selector("tag:input")				=	Returns all form input elements (input,select,textarea,button).
selector("tag:last-child")			=	Returns the last element of each child element of the statement.
selector("tag:parent")				=	Returns all elements that have no empty _content.
selector("tag:only-child")			=	Returns all elements that are the only child of their parents.
selector("tag:nth-child(x)")		=	Returns all the 'n' positioned elements for the searched 'tag' name. x can also be 'odd' or 'even'.

you can also apply attribute filters... (tag below can be any of selector statement (justed used tag to show it))
selector("tag[attribute]")						=	Returns only tags that have the 'attribute' defined.
selector("tag[attribute=value]")				=	Returns only tags that have the 'attribute' defined with the given 'value'.
selector("tag[attribute!=value]")				=	Returns only tags that not have the 'attribute' defined with the given 'value'.
selector("tag[attribute^=value]")				=	Returns only tags that have the 'attribute' defined starting with the given 'value'.
selector("tag[attribute$=value]")				=	Returns only tags that have the 'attribute' defined ending with the given 'value'.
selector("tag[attribute*=value]")				=	Returns only tags that have the 'attribute' defined containing the given 'value'.
selector("tag[attribute~=value]")				=	Returns only tags that have the 'attribute' defined containing the given 'value', delimited by spaces.
selector("tag[attribute|=value]")				=	Returns only tags that have the 'attribute' defined with given 'value' or starting with the given 'value' followed by 
													an hyphen (-).
selector("tag[attrFilter1][attrFilter1]")		=	Supports multiple attribute required filters. Here all filters must apply.

selectors can also specify parent / granparents / grangranparents selectors... 
selector("granparentTagSelector parentTagSelector childTagSelector")		=	Returns only tags that match the last selector and that are inside 'parentTagSelector',
																			    and that those are inside 'granparentTagSelector'. This allows very complex searches.

aditionally special attribute names:
i_content	=	Tag content..
i_depth		=	Depth level of tag.
i_begin		=	Char position at which starts current tag in content source.
i_end		=	Ending char position at which ends current tag in content source.


Advanced examples:
selector("img[src^=images][id]:even")				=	Returns only the even results for 'img' tags that have attribute value 'src' starting 
														with 'images' and have defined an ID attribute.
selector("img[width][height]").query("height>30")	= 	Return all img tags that have attributes width and height defined and where height is greater than 30.
selector("tr.titulo_servicios a[href] img[src]")	=	Return all img tags that have attribute 'src' defined, and that are inside a link tag (a) that has defined
														its 'src' attribute, and that these links are inside tags 'tr' with class 'titulo_servicios'.
*** from version 1.3 and above ***
Now you can use reserved characters escaping them with a backslash.
Reserved characters supported: \ ,\=,\"",\[,\],\$,\^,\*,\:,\!,\(,\),\##,\%

Examples:

selector("td[class=auctiontitle\ url]")				=	Returns all columns that have its attribute class defined with the value "auctiontitle url".
finds tags like: <td class="auctiontitle url">

selector("a[href^=\##]")							=	Returns all links that have its href attribute starting with a hash mark.
finds tags like: <a href="#about">the link</a>

--->
<cfcomponent output="no" hint="Parser helper functions using Jericho HTML parser">
	<!--- version --->
    <cfset internal=StructNew()>
	<cfset internal.version = StructNew() />
	<cfset internal.version.product = "Jericho Helper Parser" />
	<cfset internal.version.version = "1.4" />
	<cfset internal.version.author = "Pablo Schaffner" />
	<cfset internal.version.releaseDate = "4/12/2010" />
	<cfset internal.version.lastUpdate = "6/3/2012" /><!--- d/m/yyyy --->
    <cfset internal.initialized = false />
    <cfset internal.content=""><!--- current document source content --->
    <cfset internal.set_casesensitive=false><!--- be case sensitive ? --->
    <cfset internal.start_time=GetTickCount()>
    <cfset internal.end_time=GetTickCount()>
    <cfset internal.sqlscript=ArrayNew(1)><!--- all scripts executed --->
    <cfset internal.selector_tsql=ArrayNew(1)>
    <cfset internal.filters=ArrayNew(1)>
    <cfset internal.base_tag="">
    <cfset internal.sql_escape_attributes="value,from,where,null"><!--- attributes fields that are to be escaped (so queries work) --->
    <cfset this.lastquery=QueryNew("") />
    <!--- register here your own TagTypes --->
    <cfset internal.registerTags=ArrayNew(1)><!---
    <cfset internal.registerTags[1]=StructNew()>
    <cfset internal.registerTags[1].type="coldfusion tag">
    <cfif server.ColdFusion.ProductName eq "BlueDragon"><cfset internal.registerTags[1].tags=lcase(ArrayToList(GetSupportedtags("")))>
    <cfelse><cfset internal.registerTags[1].tags="cfset,cffunction,cfloop,cfif,cfelse,cftry,cfcatch,cfcomponent,cfinvoke"></cfif>    
    <cfset internal.registerTags[1].serverside=true>--->
    
    <!--- functions --->    
    <cffunction name="Init" access="Public" output="false" hint="Instanciates the parser.">
		<cfargument name="source" type="string" required="yes" hint="The file, uri or content to use as source.">
		<cfargument name="cache" type="any" required="no" default="" hint="Timespan for cache. Requires custom tag accelerate.">
		<cfargument name="justInit" type="boolean" required="no" default="false" hint="Just init, dont parse DOM.">
        <cfset source = trim(arguments.source)>
        <cfset starttime = GetTickCount()>
        <!--- cache (only for http) ? --->
        <cfset sourcetest=lcase(left(source,5))>
        <cfset sourcecache="">
        <cfif arguments.cache neq "" and (sourcetest eq "http:" or sourcetest eq "https")>
        	<cfset tmpfile=GetTempDirectory() & hash(source) & ".htm">
            <cfset tmpfile_path=GetTempDirectory()>
            <cfset tmpfile_solo=hash(source) & ".htm">
            <cfset tmpfile=tmpfile_path & tmpfile_solo>
            <cftry>
                <cfsavecontent variable="sourcecache">
                    <cf_accelerate PRIMARYKEY="parser#hash(source)#a" cachedWithin="#arguments.cache#">
                        <cfhttp url="#source#" path="#tmpfile_path#" file="#tmpfile_solo#" method="get" throwonerror="no"/>
                    </cf_accelerate>
                </cfsavecontent>
            <cfcatch type="any">
            	<!--- if cf_accelerate tag is not available --->
            	<cfhttp url="#source#" path="#tmpfile_path#" file="#tmpfile_solo#" method="get" throwonerror="no"/>
            </cfcatch>
            </cftry>
            <cfif FileExists(tmpfile)>
            	<!--- use tmpfile as source... --->
                <cfset old_source=source>
                <cfset source=tmpfile>
            </cfif>
        </cfif>
        <!--- check file uri format --->
        <cfset sourcetest=lcase(left(source,5))>
		<cfif not source contains "<" and sourcetest neq "file:" and sourcetest neq "http:">
			<cfset source = "file:///" & ReplaceNoCase(source,"\","/","ALL")>
        </cfif>
        <!--- check if we need to use JavaLoader --->
        <!--- continue --->
        <cftry>
			<cfset javaURL=createObject("java","java.net.URL").init(source)>
			<cfset internal.source = createObject("java","net.htmlparser.jericho.Source").init(javaURL)>
            <cfcatch type="any">
            	<!--- source must be text... --->
                <cfif len(source) lt 400>
					<cflog file="parsercache" text="using source as text (probably an error), source=#source#, took: #GetTickCount()-starttime# ms"/>
                </cfif>
                <cfset reader=createObject("java","java.io.StringReader").init(JavaCast("string",source))>
		        <cfset internal.source = createObject("java","net.htmlparser.jericho.Source").init(reader)>
            </cfcatch>
        </cftry>

        <!---<cfset internal.source.fullSequentialParse()>--->
        <cfset internal.content=internal.source.toString()>
		<cfset internal.HTMLElementName = createObject("java","net.htmlparser.jericho.HTMLElementName")>
        <cfset internal.SourceCompactor = createObject("java","net.htmlparser.jericho.SourceCompactor")>
       
        <cfif not arguments.justInit>
			<cfset internal.SourceFormatter = internal.source.getSourceFormatter()>
            <cfset internal.initialized = true />
            <!--- parse all tags of source --->
            <cfset internal.base_tag=this.getAllTags("",true)><!--- debugtime: getting this into cache only gets it worst --->
        </cfif>
      <cfreturn this />
    </cffunction>
    
	<!--- GENERAL METHODS AFTER INIT --->
    <cffunction name="setSource" access="public" output="no" hint="Sets the given text as the current source content">
	    <cfargument name="source" required="yes" type="string" hint="The text to use as source."/>
    	<cfif internal.initialized>
			<cfset reader=createObject("java","java.io.StringReader").init(JavaCast("string",arguments.source))>
            <cfset internal.source = createObject("java","net.htmlparser.jericho.Source").init(reader)>
            <cfset internal.source.fullSequentialParse()>
            <cfset internal.content=internal.source.toString()>
	        <cfset internal.SourceFormatter = internal.source.getSourceFormatter()>
            <cfset internal.sqlscript=ArrayNew(1)>
            <cfset internal.lastquery=QueryNew("")>
            <cfset internal.base_tag=this.getAllTags("",true)>
            <cfreturn true/>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="If this is your first call prefer method Init(file/uri/text)."/>
        </cfif>
    </cffunction>

    <cffunction name="setCaseSensitive" access="public" output="no" hint="Use case sensitive selectors and filters.">
	    <cfargument name="sensitive" required="yes" type="boolean" hint="Be case sensitive."/>
        <cfif arguments.sensitive>
        	<cfset internal.set_casesensitive=true>
        <cfelse>
	        <cfset internal.set_casesensitive=false>
        </cfif>
    </cffunction>

    <cffunction name="source" access="public" output="no" hint="Gets source object.">
    	<cfif internal.initialized>
        	<cfreturn internal.source>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>
   
    <cffunction name="registerTag" access="public" output="no" returntype="void" hint="Register TagType to be recognized. Slows selectors...">
    	<cfargument name="type" required="yes" type="string" hint="Tagtype description">
    	<cfargument name="tags" required="yes" type="string" hint="Tags to be identified as this type">
       	<cfargument name="serverside" required="yes" type="boolean" hint="Is this a serverside tag">
        <cfset internal.registerTags[arraylen(internal.registerTags)+1]=StructNew()>
        <cfset internal.registerTags[arraylen(internal.registerTags)].type=trim(arguments.type)>
        <cfset internal.registerTags[arraylen(internal.registerTags)].tags=trim(arguments.tags)>
        <cfset internal.registerTags[arraylen(internal.registerTags)].serverside=arguments.serverside>
    </cffunction>
    
    <cffunction name="getVersion" access="public" output="no" hint="Get parser version information.">
       	<cfreturn internal.version>
    </cffunction>

    <cffunction name="getTitle" access="public" output="no" hint="Get's document title.">
    	<cfif internal.initialized>
        	<cfset titleElement=internal.source.getFirstElement(internal.HTMLElementName.TITLE)>
			<!--- openbd supports null keyword and isNull() function --->
            <cfif isDefined("titleElement")><!---not isNull(titleElement)--->
            	<cfreturn titleElement.getContent().toString()>
            <cfelse>
            	<cfreturn ""/>
            </cfif>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>    

    <cffunction name="getContent" access="public" output="no" hint="Get current source content.">
    	<cfif isDefined("internal.content")>
        	<cfreturn internal.content/>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>
    
    <cffunction name="format" access="public" output="no" hint="Indents the source content.">
    	<cfargument name="IndentString" required="no" type="string" default="	" hint="Indent string to use."/>
    	<cfargument name="IndentAll" required="no" type="boolean" default="false" hint="Indent all tag elements."/>
        <cfset var result = "">
    	<cfif internal.initialized>
        	<cfset result = internal.SourceFormatter.init(internal.source)>
            <cfset result.setTidyTags(false)>
        	<cfset result.setIndentString(arguments.IndentString)>
        	<cfset result.setIndentAllElements(arguments.IndentAll)>
            <cfreturn result.toString()>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>
    
    <cffunction name="compress" access="public" output="no" hint="Compress the source content.">
    	<cfif internal.initialized>
        	<cfset result = internal.SourceCompactor.init(internal.source)>
            <cfreturn result.toString()>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>
    
    <!--- EXTRACTION METHOD 1: getAllTags --->
    <cffunction name="getAllTags" access="public" output="no" hint="Gives all instances of the given tag, its attributes and content.">
    	<cfargument name="tag" required="yes" type="string" hint="Tag to search for."/>
        <cfargument name="asQuery" required="no" default="false" type="boolean" hint="Return as query"/>
        <cfargument name="clean" required="no" default="false" type="boolean" hint="Clean query"/>
		<cfset var result=ArrayNew(1)>
        <cfset var test="">
		<cfset var all_attributes_names="">
    	<cfif internal.initialized>
            <!--- block 1: 1 ms --->
            <cfif trim(arguments.tag) neq "">
	            <cfset test=internal.source.getAllElements(trim(arguments.tag))>
            <cfelse>
            	<!--- 18-12-2010 had to comment it out because.. QUERIES are not arrays... me tupid.. --->
            	<!---<cfif isQuery(internal.base_tag)>
    				<cfset test=internal.base_tag>
                <cfelse>--->
		            <cfset test=internal.source.getAllElements()>
                <!---</cfif>--->
            </cfif>
            <!--- end block 1: 1 ms --->
            <!--- if we need to return a query, first read all attribute's names available in searched tags --->
            <cfif arguments.asQuery>
                <cfloop index="Tag" array="#test#">
                    <cfset tmp=Tag.getAttributes()>
                    <cftry>
                        <cfloop index="wAt" array="#tmp#">
                        	<cfset tmpnewat=wAt.getName()>
                            <cfset tmpnewat=ReplaceNoCase(tmpnewat,"-","_","ALL")><!--- for http-equiv like columns to http_equiv--->
                            <cfif left(tmpnewat,1) eq "_"><cfset tmpnewat="i" & tmpnewat></cfif><!--- SEAN HYNES BUG Nº 2 12/12/2011 --->
                            <!--- escape reserved SQL words in columnNames (only for query type) --->
                            <cfif arguments.asQuery>
                            	<cfif ListContains(internal.sql_escape_attributes,lcase(tmpnewat))>
                                	<cfset tmpnewat="i_" & tmpnewat>
                                </cfif>
                            </cfif>
                            <cfif ListFindNoCase(all_attributes_names,tmpnewat) eq 0>
                                <cfset all_attributes_names=ListAppend(all_attributes_names,tmpnewat)>
                            </cfif>
                        </cfloop>
                        <cfcatch type="any">
                        </cfcatch>
                    </cftry>
                </cfloop>
            </cfif>
            <!--- continue --->
            <cfloop index="Tag" array="#test#">
				<cfset result[arraylen(result)+1]=StructNew()>
                <!---<cfset result[arraylen(result)]._object=Tag>--->
                <cfset result[arraylen(result)].i_row=arraylen(result)>
                <cfset result[arraylen(result)].i_tag_full=Tag.toString()>
                <cfset result[arraylen(result)].i_tag_start=Tag.getStartTag().toString()>
                <cftry>
	                <cfset result[arraylen(result)].i_tag_end=Tag.getEndTag().toString()>
                    <cfcatch type="any">
	   	                <cfset result[arraylen(result)].i_tag_end=""><!--- not all tags have closing tags --->
                    </cfcatch>
                </cftry>
                <cfset result[arraylen(result)].i_tag_name=Tag.getName()>
                <cfif result[arraylen(result)].i_tag_name contains ":">
                	<cfset result[arraylen(result)].i_tag_prefix=listfirst(result[arraylen(result)].i_tag_name,":")>
                <cfelse>
                	<cfset result[arraylen(result)].i_tag_prefix="">
                </cfif>
                <!--- tag type --->
                <cfset identified=0>
                <cfloop index="wTagType" from="1" to="#arraylen(internal.registerTags)#" step="+1">
                	<cfif ListFindNoCase(internal.registerTags[wTagType].tags,result[arraylen(result)].i_tag_name) gt 0>
						<cfset identified=wTagType>
                    </cfif>
                </cfloop>
                <!--- assign --->
                <cfif identified neq 0>
					<cfset result[arraylen(result)].i_tag_is_serverside=internal.registerTags[identified].serverside>
                    <cfset result[arraylen(result)].i_tag_type=internal.registerTags[identified].type>
                <cfelse>
                	<cfset i_tag_type=Tag.getStartTag().getTagType()>
					<cfset result[arraylen(result)].i_tag_is_serverside=i_tag_type.isServerTag()>
                    <cfif result[arraylen(result)].i_tag_is_serverside eq "YES">
                    	<cfset result[arraylen(result)].i_tag_is_serverside=true>
                    <cfelse>
	                    <cfset result[arraylen(result)].i_tag_is_serverside=false>
                    </cfif>
                    <cfset result[arraylen(result)].i_tag_type=i_tag_type.getDescription()>
                </cfif>
                <!--- end type --->
                <cfset result[arraylen(result)].i_begin=Tag.getBegin()><!---
                <cfset result[arraylen(result)].i_begin_row=internal.source.getRowColumnVector(Tag.getBegin()).getRow()>
                <cfset result[arraylen(result)].i_begin_col=internal.source.getRowColumnVector(Tag.getBegin()).getColumn()>--->
                <cfset result[arraylen(result)].i_end=Tag.getEnd()><!---
                <cfset result[arraylen(result)].i_end_row=internal.source.getRowColumnVector(Tag.getEnd()).getRow()>
                <cfset result[arraylen(result)].i_end_col=internal.source.getRowColumnVector(Tag.getEnd()).getColumn()>
                <cfset result[arraylen(result)]._length=Tag.length()>--->
                <cfset result[arraylen(result)].i_depth=Tag.getDepth()>
                <cfset result[arraylen(result)].i_content=Tag.getContent().toString()>
                <!---<cfset result[arraylen(result)].i_contentWithoutHtml=Tag.getContent().getRenderer().toString()>--->
                <!---<cfset result[arraylen(result)].i_contenttext=cleanTags(result[arraylen(result)].i_content)>--->
                <cfif not arguments.asQuery>
	                <cfset result[arraylen(result)].i_attributes=ArrayNew(1)>
                <cfelse>
                	<!--- add keys to structs of all_attributes_names values --->
                    <cfloop index="x" list="#all_attributes_names#">
	                    <cfset StructInsert(result[arraylen(result)],x,"",true)>
                    </cfloop>
                </cfif>
                <cfset attributes=Tag.getAttributes()>
                <cftry>
                    <cfloop index="wAttr" array="#attributes#">
                    	<cfif not arguments.asQuery>
							<cfset result[arraylen(result)].i_attributes[arraylen(result[arraylen(result)].i_attributes)+1]=StructNew()>
                            <cfset result[arraylen(result)].i_attributes[arraylen(result[arraylen(result)].i_attributes)].name=wAttr.getName()>
                            <cfset result[arraylen(result)].i_attributes[arraylen(result[arraylen(result)].i_attributes)].value=wAttr.getValue()>
                        <cfelse>
                        	<!--- escape reserved SQL words in query attributes --->
                            <cfset tmpnewat=wAttr.getName()>
                            <cfif left(tmpnewat,1) eq "_"><cfset tmpnewat="i" & tmpnewat></cfif><!--- SEAN HYNES BUG Nº 2 12/12/2011 --->
							<cfif ListContains(internal.sql_escape_attributes,lcase(tmpnewat))>
                                <cfset tmpnewat="i_" & tmpnewat>
                            </cfif>
                        	<cfset StructInsert(result[arraylen(result)],tmpnewat,wAttr.getValue(),true)>
                        </cfif>
                    </cfloop>
                    <cfcatch type="any"><!--- not all tags have attributes... --->
                    </cfcatch>
                </cftry>
            </cfloop>
			<cfif arguments.asQuery>
            	<cfset resp=struct2query(result)>
				<cfif arguments.clean>
                    <cfset this.lastquery=removeEmptyColumns(resp)>
                <cfelse>
                    <cfset this.lastquery=resp>
                </cfif>
                <cfreturn this.lastquery />

            </cfif>
        	<cfreturn result/>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method Init(file)."/>
        </cfif>
    </cffunction>

	<!--- EXTRACTION METHOD 2: selector --->
 	<cffunction name="selector" access="public" output="no" hint="Helper function to access tags and elements as jQuery selector usage.">
    	<cfargument name="parameter" required="yes" type="string" default="" hint="Selector."/>
    	<cfargument name="clean" required="no" type="boolean" default="true" hint="Clean unused columns"/>
        <cfset var base=internal.base_tag><!--- base query --->
        <cfset clean_vars()><!--- clean previously used variables.. --->
       	<!--- Escape 'escaped \\chars' --->
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\ ",URLEncodedFormat(" ","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\=",URLEncodedFormat("=","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\""",URLEncodedFormat("""","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\[",URLEncodedFormat("[","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\]",URLEncodedFormat("]","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\$",URLEncodedFormat("$","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\^",URLEncodedFormat("^","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\*",URLEncodedFormat("*","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\:",URLEncodedFormat(":","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\!",URLEncodedFormat("!","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\(",URLEncodedFormat("(","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\)",URLEncodedFormat(")","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\##",URLEncodedFormat("##","utf-8"),"ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,"\%",URLEncodedFormat("%","utf-8"),"ALL")>
        <!--- continue --->
        <cfif listlen(arguments.parameter," ") eq 1>
        	<cfset nill=selectorHelperMain(arguments.parameter,arguments.clean,base)>
        <cfelseif base.recordCount neq 0>
			<!--- multiple space separated selectors --->
            <cfset selection=trim(arguments.parameter)>
			<cfset multiple=ArrayNew(1)>
            <cfloop index="cSel" from="1" to="#listlen(selection,' ')#" step="+1">
                <cfset wSel=ListGetAt(selection,cSel," ")>
                <!--- call current selector --->
                <cfset parent=selectorHelperMain(wSel,false,base,false).query()><!--- dont apply filters to parent query --->
				<!--- get parent where clause... so that child query knows of it (not necesary to execute it.. but needed to inform of it --->
                <cfset parent_where_clause=internal.sqlscript[arraylen(internal.sqlscript)].sql>
				<cfset pt_where=""><cfset ptw_where="">
                <cfif parent_where_clause contains "where">
                    <cfset pt_where=Right(parent_where_clause,len(parent_where_clause)-FindNoCase("where",parent_where_clause)+1)>
                    <cfset ptw_where=right(pt_where,len(pt_where)-5)>
                </cfif>
                <!--- filter with parent ranges --->
                <cfif cSel eq 1 and parent.recordCount gt 0>
                    <cfset multiple[arraylen(multiple)+1]=StructNew()>
                    <cfset multiple[arraylen(multiple)].query=parent>
                    <cfset multiple[arraylen(multiple)].begins="">
                    <cfset multiple[arraylen(multiple)].ends="">
                    <cfloop query="parent">
                        <cfset multiple[arraylen(multiple)].begins=ListAppend(multiple[arraylen(multiple)].begins,parent.i_begin)>
                        <cfset multiple[arraylen(multiple)].ends=ListAppend(multiple[arraylen(multiple)].ends,parent.i_end)>
                    </cfloop>
                    <!--- maybe here we should loop for aa.recordcount filtering each result and comparing it to the next selector... --->        
                <cfelseif cSel neq 1 and parent.recordCount gt 0>
                    <cfset multiple[arraylen(multiple)+1]=StructNew()>
                    <cfset where="">
                    <cfloop index="wRange" from="1" to="#listlen(multiple[arraylen(multiple)-1].begins)#" step="+1">
                        <cfset tmp_begin=ListGetAt(multiple[arraylen(multiple)-1].begins,wRange)>
                        <cfset tmp_end=ListGetAt(multiple[arraylen(multiple)-1].ends,wRange)>
                        <cfif wRange eq 1>
                            <cfset tmp="(i_begin>#tmp_begin# and i_end<#tmp_end#)">
                        <cfelse>
                            <cfset tmp=" or (i_begin>#tmp_begin# and i_end<#tmp_end#)">
                        </cfif>
                        <cfset where=ListAppend(where,tmp," ")>
                    </cfloop>
                    <!--- --->
					<cfif ptw_where neq "">
                    	<cfset parent_cfcmd="select * from parent where (#where#) and #ptw_where#">
                    <cfelse>
						<cfset parent_cfcmd="select * from parent where (#where#)">
                    </cfif>
                    <cfquery name="newo" dbtype="query" result="sql">
                    #PreserveSingleQuotes(parent_cfcmd)#
                    </cfquery>
                    <cfset this.lastquery=newo>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sql>
					<cfif wSel contains internal.filters[arraylen(internal.filters)] and trim(internal.filters[arraylen(internal.filters)]) neq "">
                        <cfset newo=_filter(internal.filters[arraylen(internal.filters)])><!--- apply current selector filter to all previous queries --->
                    </cfif>
                    <cfset multiple[arraylen(multiple)].query=newo>
                    <cfif newo.recordCount neq 0>
                        <cfset multiple[arraylen(multiple)].begins="">
                        <cfset multiple[arraylen(multiple)].ends="">
                        <cfloop query="newo">
                            <cfset multiple[arraylen(multiple)].begins=ListAppend(multiple[arraylen(multiple)].begins,newo.i_begin)>
                            <cfset multiple[arraylen(multiple)].ends=ListAppend(multiple[arraylen(multiple)].ends,newo.i_end)>
                        </cfloop>
                    <cfelse>
                        <cfbreak/>
                    </cfif>
                <cfelse>
                    <cfbreak/>
                </cfif>
            </cfloop>
            <!--- --->
            <cfif arraylen(multiple) gt 0>
	            <cfset resp=multiple[arraylen(multiple)].query>
            <cfelse>
            	<cfset resp=QueryNew(base.columnlist)>
            </cfif>
			<!--- end --->
            <cfif arguments.clean>
                <cfset this.lastquery=removeEmptyColumns(resp)>
            <cfelse>
                <cfset this.lastquery=resp>
            </cfif>
        <cfelse>
        	<cfset this.lastquery=base>
        </cfif>
        <cfset internal.end_time=GetTickCount()>
        <cfreturn this/>
    </cffunction>
 
 	<cffunction name="selectorHelperMain" access="private" output="no" hint="Helper function to access tags and elements as jQuery selector usage.">
    	<cfargument name="parameter" required="yes" type="string" default="" hint="Selector."/>
    	<cfargument name="clean" required="no" type="boolean" default="false" hint="Clean unused columns"/>
    	<cfargument name="basequery" required="no" type="query" default="" hint="Base query."/>
    	<cfargument name="applyfilter" required="no" type="boolean" default="true" hint="Apply existing filter."/>
        <cfset internal.sqlscript=ArrayNew(1)><!--- reset sql script --->
        <cfif IsQuery(arguments.basequery)>
        	<cfset base=arguments.basequery>
        <cfelse>
			<cfset base=internal.base_tag><!--- base query --->
		</cfif>
        <!--- continue --->
		<cfif base.recordCount neq 0>
			<!--- continue to deliver result --->
            <cfif listlen(trim(arguments.parameter)) eq 2>
                <!--- 2 selectors --->
                <cfset resp_a=selectorHelper(base,ListFirst(arguments.parameter),arguments.applyfilter)>
                <cfset resp_b=selectorHelper(base,ListLast(arguments.parameter),arguments.applyfilter)>
                <cfset resp=queryConcat(resp_a,resp_b)>
            <cfelseif listlen(trim(arguments.parameter)) eq 3>
                <!--- 3 selectors --->
                <cfset resp_a=selectorHelper(base,ListFirst(arguments.parameter),arguments.applyfilter)>
                <cfset resp_b=selectorHelper(base,ListGetAt(arguments.parameter,2),arguments.applyfilter)>
                <cfset resp_ab=queryConcat(resp_a,resp_b)>
                <cfset resp_c=selectorHelper(base,ListLast(arguments.parameter),arguments.applyfilter)>
                <cfset resp=queryConcat(resp_ab,resp_c)>
            <cfelseif listlen(trim(arguments.parameter)) gt 1>
            	<!--- more than 3 selectors, not supported --->
            <cfelse>
                <!--- 1 selector --->
                <cfset resp=selectorHelper(base,arguments.parameter,arguments.applyfilter)>
            </cfif>
    
            <!--- return result --->
            <cfif arguments.clean>
                <cfset this.lastquery=removeEmptyColumns(resp)>
            <cfelse>
                <cfset this.lastquery=resp>
            </cfif>
		<cfelse>
        	<cfset this.lastquery=base>
        </cfif>

        <cfreturn this/>
    </cffunction>    
    
	<!--- GENERAL METHODS FOR SELECTOR --->
    <cffunction name="query" access="public" output="no" hint="Returns the lastquery variable.">
	    <cfargument name="parameter" required="no" type="string" default="" hint="Filter."/>
	    <cfargument name="asquery" required="no" type="boolean" default="true" hint="Return as query."/>
    	<cfif isQuery(this.lastquery)>
        	<cfif trim(arguments.parameter) neq "">
            	<cftry>
                	<cfset query_where=this.lastquery>
                	<cfset sqstat="select * from query_where where " & trim(arguments.parameter)>
                    <cfquery name="newwh" dbtype="query" result="sq_script">
                    #PreserveSingleQuotes(sqstat)#
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=newwh>
                    <cfif arguments.asquery>
	                    <cfreturn this.lastquery>
                    <cfelse>
	                    <cfreturn this>
                    </cfif>
                	<cfcatch type="any">
                		<cfreturn QueryNew("")>
                    </cfcatch> 
                </cftry>
            <cfelse>
	            <cfreturn this.lastquery>
            </cfif>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>

    <cffunction name="sql" access="public" output="no" hint="Returns the all the sql scripts executed in order.">
    	<cfif isQuery(this.lastquery)>
            <cfreturn internal.sqlscript>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>
    
    <cffunction name="querySelectors" access="public" output="no" hint="Returns the all queries that creates the selectos.">
        <cfreturn internal.selector_tsql>
    </cffunction>
    
    

    <cffunction name="time" access="public" output="no" hint="Time it took to execute selector.">
    	<cfif isQuery(this.lastquery)>
        	<cfset time_ms=internal.end_time-internal.start_time>
            <cfreturn time_ms>
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction> 
    
    <!--- ***************************  --->
    <!--- PUBLIC METHODS FOR SELECTOR  --->
    <!--- ***************************  --->
    <!--- parents (only if children are inside! (of course)) --->
    <cffunction name="parents" access="public" output="no" hint="Get the ancestors of each element in the current set of matched elements, optionally filtered by a selector.">
	    <cfargument name="selector" required="no" type="string" default="" hint="Selector to search for ancesters."/>
        <cfargument name="clean" required="no" type="boolean" default="true" hint="Clean unused columns."/>
    	<cfif isQuery(this.lastquery)>
        	<!--- get i_begin and i_end for each records in lastquery --->
            <cfset _begins=""><cfset _ends="">
            <cfloop query="this.lastquery">
            	<cfif ListFindNoCase(_begins,this.lastquery.i_begin) eq 0>
                	<cfset _begins=ListAppend(_begins,this.lastquery.i_begin)>
                	<cfset _ends=ListAppend(_ends,this.lastquery.i_end)>
                </cfif>
            </cfloop>
            <cfif arguments.selector eq ""><cfset arguments.selector="*"></cfif>
            <!--- filter with given selector --->
            <cfset selectorHelper(internal.base_tag,arguments.selector,true)>
            <cfset prenew=this.lastquery>
            <!--- get ALL the ancestors for each record in the previous selector --->
            <cfset not_repeat="">
			<cfloop index="testParent" from="1" to="#listlen(_begins)#" step="+1">
            	<cfset c_begin=ListGetAt(_begins,testParent)>
                <cfset c_end=ListGetAt(_ends,testParent)>
                <cfset c_sql="select i_row from prenew where i_begin < #c_begin# and i_end > #c_end# and i_tag_type not like '%declaration'">
                <cfquery name="newonep" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(c_sql)#
                </cfquery>
                <cfloop query="newonep">
                	<cfif ListFindNoCase(not_repeat,newonep._row) eq 0>
                    	<cfset not_repeat=ListAppend(not_repeat,newonep.i_row)>
                    </cfif>
				</cfloop>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            </cfloop>
			<cfif not_repeat neq "">
            	<!--- JOIN the found ancestors --->
            	<cfquery name="newone" dbtype="query" result="sq_script">
                	select * from prenew where i_row in (#not_repeat#)
                </cfquery>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <!--- clean unused attributes ? --->
				<cfif arguments.clean>
                    <cfset this.lastquery=removeEmptyColumns(newone)>
                <cfelse>
                    <cfset this.lastquery=newone>
                </cfif>
            </cfif>
            <cfreturn this/>
        <cfelse>
        	<cfthrow type="parser.parents" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction> 

    <!--- parent(x) --->
    <cffunction name="parent" access="public" output="no" hint="Get the parent of each element in the current set of matched elements, optionally filtered by a selector.">
	    <cfargument name="selector" required="no" type="string" default="" hint="Selector to filter parent for."/>
        <cfargument name="clean" required="no" type="boolean" default="true" hint="Clean unused columns."/>
    	<cfif isQuery(this.lastquery)>
        	<!--- get _begin and _end for each record in lastquery --->
            <cfset _begins=""><cfset _ends="">
            <cfloop query="this.lastquery">
            	<cfif ListFindNoCase(_begins,this.lastquery.i_begin) eq 0>
                	<cfset _begins=ListAppend(_begins,this.lastquery.i_begin)>
                	<cfset _ends=ListAppend(_ends,this.lastquery.i_end)>
                </cfif>
            </cfloop>
            <cfif arguments.selector eq ""><cfset arguments.selector="*"></cfif>
            <!--- filter with given selector --->
            <cfset selectorHelper(internal.base_tag,arguments.selector,true)>
            <cfset prenew=this.lastquery>
            <!--- get ALL the ancestors for each record in the previous selector --->
            <cfset not_repeat="">
			<cfloop index="testParent" from="1" to="#listlen(_begins)#" step="+1">
            	<cfset c_begin=ListGetAt(_begins,testParent)>
                <cfset c_end=ListGetAt(_ends,testParent)>
                <cfset c_sql="select * from prenew where i_begin < #c_begin# and i_end > #c_end# and i_tag_type not like '%declaration'">
                <cfquery name="newonep" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(c_sql)#
                </cfquery>
                <cfif newonep.recordCount neq 0><!--- grab ONLY the Lastone for each previous record --->
                	<cfif ListFindNoCase(not_repeat,newonep.i_row[newonep.recordCount]) eq 0>
                    	<cfset not_repeat=ListAppend(not_repeat,newonep.i_row[newonep.recordCount])>
                    </cfif>
				</cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            </cfloop>
            <cfif not_repeat neq "">
                <!--- JOIN the found ancestor of records --->
                <cfquery name="newone" dbtype="query" result="sq_script">
                    select * from prenew where i_row in (#not_repeat#)
                </cfquery>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <!--- clean unused attributes ? --->
                <cfif arguments.clean>
                    <cfset this.lastquery=removeEmptyColumns(newone)>
                <cfelse>
                    <cfset this.lastquery=newone>
                </cfif>
            </cfif>
            <cfreturn this/>
        <cfelse>
        	<cfthrow type="parser.parent" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction> 
    
    <!--- closest(x) --->
    <cffunction name="closest" access="public" output="no" hint="Get the first ancestor element that matches the selector, beginning at the current element and progressing up through the DOM tree.">
	    <cfargument name="selector" required="yes" type="string" default="" hint="Selector to search for. Only basic selectors for the moment."/>
        <cfargument name="clean" required="no" type="boolean" default="true" hint="Clean unused columns."/>
        <!--- this must return only 1 result or none.. (as saids the jquery closest specification) --->
    	<cfif isQuery(this.lastquery) and arguments.selector neq "">
        	<!--- get _begin and _end for each records in lastquery --->
            <cfset _begins=""><cfset _ends="">
            <!--- grab the FIRST record ONLY --->
            <cfif this.lastquery.recordCount neq 0>
            	<cfset _begins=this.lastquery.i_begin>
                <cfset _ends=this.lastquery.i_end>
				<!--- filter with given selector --->
                <cfset selectorHelper(internal.base_tag,arguments.selector,true)>
                <cfset prenew=this.lastquery>
                <!--- get ALL the ancestors for each record in the previous selector --->
                <!--- we do this little messy round thing because cfquery of queries in bluedragon doesn't have the TOP/BOTTOM keywords (at least they don't work) --->
                <cfset last_record="">
                <cfset c_sql="select * from prenew where i_begin < #_begins# and i_end > #_ends# and i_tag_type not like '%declaration'">
                <cfquery name="newonep" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(c_sql)#
                </cfquery>
                <!--- Grab the LAST record ONLY --->
                <cfif newonep.recordcount neq 0>
                    <cfset last_record=ListAppend(last_record,newonep.i_row[newonep.recordCount])>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <cfif last_record neq "">
                    <!--- JOIN the found ancestors --->
                    <cfquery name="newone" dbtype="query" result="sq_script">
                        select * from prenew where i_row=#last_record#
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <!--- clean unused attributes ? --->
                    <cfif arguments.clean>
                        <cfset this.lastquery=removeEmptyColumns(newone)>
                    <cfelse>
                        <cfset this.lastquery=newone>
                    </cfif>
                </cfif>
            </cfif>
            <cfreturn this/>
		<cfelseif arguments.selector eq "">
        	<cfthrow type="parser.closest" message="You must specify the selector attribute for the closest method."/>
        <cfelse>
        	<cfthrow type="parser.closest" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction> 
    
    <!--- filter --->
    <cffunction name="filter" access="public" output="no" hint="Filters the lastquery query as with the complete given selector.">
	    <cfargument name="selector" required="yes" type="string" default="" hint="Selector to use as filter."/>
        <cfargument name="clean" required="no" type="boolean" default="true" hint="Clean unused columns."/>
        <cfif isQuery(this.lastquery) and trim(arguments.selector) neq "">
        	<cfif this.lastquery.recordCount eq 0>
            	<cfreturn this/><!--- nothing to filter --->
            </cfif>
			<!--- start --->
        	<!--- get _begin and _end for each record in lastquery --->
            <cfset _begins=""><cfset _ends="">
            <cfloop query="this.lastquery">
            	<cfif ListFindNoCase(_begins,this.lastquery.i_begin) eq 0>
                	<cfset _begins=ListAppend(_begins,this.lastquery.i_begin)>
                	<cfset _ends=ListAppend(_ends,this.lastquery.i_end)>
                </cfif>
            </cfloop>
            <cfif arguments.selector eq ""><cfset arguments.selector="*"></cfif>
            <!--- filter with given selector --->
            <cfset selectorHelper(internal.base_tag,arguments.selector,true)>
            <cfset prenew=this.lastquery>
            <cfif prenew.recordCount eq 0>
            	<cfreturn this/><!--- nothing else to filter --->
            </cfif>
            <!--- get ALL the children for each record in the previous selector --->
            <cfset not_repeat="">
			<cfloop index="testParent" from="1" to="#listlen(_begins)#" step="+1">
            	<cfset c_begin=ListGetAt(_begins,testParent)>
                <cfset c_end=ListGetAt(_ends,testParent)>
                <cfset c_sql="select * from prenew where i_begin > #c_begin# and i_end < #c_end#">
                <cfquery name="newonep" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(c_sql)#
                </cfquery>
                <cfloop query="newonep"><!--- dont repeat values.. --->
                	<cfif ListFindNoCase(not_repeat,newonep.i_row) eq 0>
                    	<cfset not_repeat=ListAppend(not_repeat,newonep.i_row)>
                    </cfif>
				</cfloop>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            </cfloop>
            <cfif not_repeat neq "">
                <!--- JOIN the found ancestor of records --->
                <cfquery name="newone" dbtype="query" result="sq_script">
                    select * from prenew where i_row in (#not_repeat#)
                </cfquery>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <!--- clean unused attributes ? --->
                <cfif arguments.clean>
                    <cfset this.lastquery=removeEmptyColumns(newone)>
                <cfelse>
                    <cfset this.lastquery=newone>
                </cfif>
            </cfif>
			<!--- end --->
		<cfelseif arguments.selector eq "">
            <cfthrow type="parser.filter" message="You must specify the selector attribute for the filter method."/>
        <cfelse>
            <cfthrow type="parser.filter" message="You must first call method getAllTags or selector."/>
        </cfif>
        <cfreturn this/>
    </cffunction>    
    
    <!--- html --->
	<cffunction name="html" access="public" output="no" hint="Get or sets the HTML contents of the first element in the set of matched elements.">
		<cfargument name="content" required="no" type="string" default="" hint="Optional html/xml content to replace with."/>
        <cfif isQuery(this.lastquery)>
        	<cfif this.lastquery.recordCount neq 0>
				<cfif arguments.content eq "">
                    <cfreturn this.lastquery.i_content/>
                <cfelse>
                    <!--- order from begining position.. --->
                    <cfset currenti=this.lastquery>
                    <cfset new_content=internal.content>
                    <cfquery name="bydepth" dbtype="query">
                    select i_begin,i_content from currenti order by i_begin
                    </cfquery>
                    <cfset plus_len_content=0>
                    <cfloop query="bydepth">
                    	<cfif bydepth.i_content neq "">
							<cfset new_content=ReplaceAt(new_content, bydepth.i_content, arguments.content, bydepth.i_begin+plus_len_content)>
                            <cfset plus_len_content=Min(0,plus_len_content-len(bydepth.i_content))>
                        </cfif>
                    </cfloop>
                    <!--- refreshes the DOM if new is different than original --->
                    <cfif len(internal.content) neq len(new_content)>
	                    <cfset this.setSource(new_content)>
                    </cfif>
                    <cfreturn ""/>
                </cfif>
			<cfelseif trim(arguments.content) eq "">
				<cfreturn ""/>
            <cfelse>
            	<cfreturn ""/>
            </cfif>
        <cfelse>
	        <cfthrow type="parser.html" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>

	<!--- removeTags --->
    <cffunction name="removeTags" access="public" output="no" hint="Removes all tags from the given string - helper function">
    	<cfargument name="string" required="yes" type="string" default="" hint="string to be cleaned"/>
        <cfset tmpres=trim(REReplaceNoCase(arguments.string,"<[^>]*>","","ALL"))>
		<cfreturn tmpres/>
    </cffunction>

    <!--- getNumbers --->
    <cffunction name="getNumbers" access="public" returntype="array" output="no" hint="Gets an array with all numbers (as text) found on the current selector.">
    	<cfset theText=text()>
        <cfset tmpNew=ArrayNew(1)>
        <cfloop index="wWord" list="#theText#" delimiters=" ">
        	<cfif IsNumeric(trim(wWord))>
            	<cfset tmpNew[arraylen(tmpNew)+1]=trim(wWord)>
            </cfif>
        </cfloop>
        <cfreturn tmpNew/>
    </cffunction>
    
    <!--- text --->
	<cffunction name="text" access="public" output="no" hint="Get the combined text contents of each element in the set of matched elements, including their descendants.">
		<cfargument name="content" required="no" type="string" default="" hint="Optional html/xml content (escaped) to replace with."/>
        <cfif isQuery(this.lastquery)>
        	<cfif this.lastquery.recordCount neq 0>
				<cfif arguments.content eq "">
                	<!--- get all _contents and removetags --->
                    <cfset _new_content="">
                    <cfloop query="this.lastquery">
                    	<cfset _new_content=_new_content & this.lastquery.i_content>
                    </cfloop>
                    <!--- removetags from _new_content --->
                    <cfset _new_contentb=trim(REReplaceNoCase(_new_content,"<[^>]*>","","ALL"))>
                    <!--- return _new_content --->
                    <cfreturn _new_contentb/>
                <cfelse>
                    <!--- order from begining position.. --->
                    <cfset currenti=this.lastquery>
                    <cfset new_content=internal.content>
                    <cfquery name="bydepth" dbtype="query">
                    select i_begin,i_content from currenti order by i_begin
                    </cfquery>
                    <!--- escape html/xml symbols from arguments.content --->
                    <cfset arguments.content=ReplaceNoCase(arguments.content,"<","&lt;","ALL")>
                    <cfset arguments.content=ReplaceNoCase(arguments.content,">","&gt;","ALL")>
                    <cfset arguments.content=ReplaceNoCase(arguments.content,"&","&amp;","ALL")>
                    <cfset arguments.content=ReplaceNoCase(arguments.content,"""","&quot;","ALL")>
                    <cfset plus_len_content=0>
                    <cfloop query="bydepth">
                    	<cfif bydepth.i_content neq "">
							<cfset new_content=ReplaceAt(new_content, bydepth.i_content, arguments.content, bydepth.i_begin+plus_len_content)>
                            <cfset plus_len_content=Min(0,plus_len_content-len(bydepth.i_content))>
                        </cfif>
                    </cfloop>
                    <!--- refreshes the DOM if new is different than original --->
                    <cfif len(internal.content) neq len(new_content)>
	                    <cfset this.setSource(new_content)>
                    </cfif>
                    <cfreturn ""/>
                </cfif>
			<cfelseif trim(arguments.content) eq "">
				<cfreturn ""/>
            <cfelse>
            	<cfreturn ""/>
            </cfif>
        <cfelse>
	        <cfthrow type="parser.text" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>

    <!--- replaceWith(x) (different of html as this replaces the i_tag_full data)--->
	<cffunction name="replaceWith" access="public" output="no" hint="Replaces each instances of the matched elements with the given content.">
		<cfargument name="content" required="yes" type="string" default="" hint="New content to place."/>
        <cfif isQuery(this.lastquery)>
        	<cfif this.lastquery.recordCount neq 0>
                <!--- order from begining position.. --->
                <cfset currenti=this.lastquery>
                <cfset new_content=internal.content>
                <cfquery name="bydepth" dbtype="query">
                select i_begin,i_tag_full from currenti order by i_begin
                </cfquery>
                <cfset plus_len_content=0>
                <cfloop query="bydepth">
                    <cfif bydepth.i_tag_full neq "">
                        <cfset new_content=ReplaceAt(new_content, bydepth.i_tag_full, arguments.content, bydepth.i_begin+plus_len_content)>
                        <cfset plus_len_content=Min(0,plus_len_content-len(bydepth.i_tag_full))>
                    </cfif>
                </cfloop>
                <!--- refreshes the DOM if new is different than original --->
                <cfif len(internal.content) neq len(new_content)>
                    <cfset this.setSource(new_content)>
                </cfif>
                <cfreturn ""/>
            <cfelse>
            	<cfreturn ""/>
            </cfif>
        <cfelse>
	        <cfthrow type="parser.replaceWith" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>

    <!--- ***************** --->
    <!--- PRIVATE FUNCTIONS --->
    <!--- ***************** --->
        
    <cffunction name="removeEmptyColumns" access="private" returntype="query" output="no" hint="Cleans the given query to delete columns without values in all rows">
    	<cfargument name="query" required="yes" type="query" hint="The query to clean">
        <cfset in_use="">
		<cfif arguments.query.recordCount neq 0>
            <cfloop index="wCol" list="#arguments.query.columnlist#">
            	<cfset used=false>
            	<cfloop index="wRow" from="1" to="#arguments.query.recordCount#" step="+1">
                	<cfif arguments.query[wCol][wRow] neq "" or ListFindNoCase("i_content",wCol) neq 0><!--- put here columns that must not be erased --->
                    	<cfset used=true>
                   	</cfif>
                </cfloop>
                <cfif used>
	                <cfset in_use=ListAppend(in_use,wCol)>
                </cfif>
           </cfloop>
           <cftry>
               <cfquery name="resp" dbtype="query" result="sq_script">
               select #in_use# from arguments.query
               </cfquery>
               <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
               <cfreturn resp />
			   <cfcatch type="any">
               		<cfreturn arguments.query>
               </cfcatch>
           </cftry>
        <cfelse>
        	<cfreturn arguments.query />
        </cfif>
    </cffunction>
    <cffunction name="clean_vars" access="private" output="no" hint="Resets variables">
    	<cfif isQuery(this.lastquery)>
			<cfset internal.sqlscript=ArrayNew(1)><!--- all scripts executed --->
            <cfset internal.selector_tsql=ArrayNew(1)>
            <cfset internal.filters=ArrayNew(1)>        	
			<cfset internal.start_time=GetTickCount()>
            <cfset internal.end_time=GetTickCount()>
		</cfif>
    </cffunction>
	<!--- --->
	<!--- called from selectorHelper and selectorHelperNot --->
    <cffunction name="_filter" access="public" output="no" hint="Filters the lastquery query as with jQuery filters.">
	    <cfargument name="parameter" required="yes" type="string" default="" hint="Filter."/>
        <cfset var param=trim(arguments.parameter)>
        <cfset var base="">
        <cfif left(param,1) neq ":"><cfset param=":" & param></cfif>
    	<cfif isQuery(this.lastquery)>
			<cfset base=this.lastquery>
            <cfif base.recordCount eq 0>
                <cfreturn this.lastquery/>
            </cfif>
			<!--- BASIC CHECKS --->
            <cfswitch expression="#param#">
                <!--- basic filters (even,odd,first,last,header) --->
            	<cfcase value=":first">
                	<cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_row=#base.i_row[1]#
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":last">
                	<cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_row=#base.i_row[base.recordCount]#
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
					<cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":even">
                	<cfset even_rows="">
                    <cfloop query="base">
                    	<cfif base.currentRow mod 2 eq 0><!--- changed from i_row to currentRow, because are EVEN RESULTS, not i_rowS :: PSB ! --->
                        	<cfset even_rows=ListAppend(even_rows,base.i_row)>
                        </cfif>
                    </cfloop>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_row in (#even_rows#)
                    </cfquery>
                    
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":odd">
                	<cfset odd_rows="">
                    <cfloop query="base">
                    	<cfif base.currentRow mod 2 neq 0>
                        	<cfset odd_rows=ListAppend(odd_rows,base.i_row)>
                        </cfif>
                    </cfloop>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_row in (#odd_rows#)
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":header">
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(_tag_name) in ('h1','h2','h3','h4','h5','h6')
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
				<!--- child filters (first-child,last-child,only-child) --->
            	<cfcase value=":first-child,:last-child,:only-child">
                	<cfset queryall=internal.base_tag>
                    <!--- extract current tsql script where clause --->
                    <cfset tsql_current=internal.sqlscript[arraylen(internal.sqlscript)].sql>
                    <cfset t_where=""><cfset tw_where="">
                    <cfif tsql_current contains "where">
                    	<cfset t_where=Right(tsql_current,len(tsql_current)-FindNoCase("where",tsql_current)+1)>
                        <cfset tw_where=right(t_where,len(t_where)-5)>
                    </cfif>
                    <!--- get parent of current query --->
                    <cfif arraylen(internal.selector_tsql) gt 1>
	                    <cfset base=internal.selector_tsql[arraylen(internal.selector_tsql)-1]>
                    <cfelse>
                    	<!--- no parents.. so we want to search all tags --->
                        <cfset base=queryall>
                    </cfif>
                    <cfset _rows="">
                    <cfloop index="wfc" from="1" to="#base.recordcount#" step="+1">
                    	<cfset tmp_begin=base.i_begin[wfc]>
                        <cfset tmp_end=base.i_end[wfc]>
                        <cfset tmp_where="i_begin>#tmp_begin# and i_end<#tmp_end# and #tw_where#">
                    	<!--- we use queryall query here, because we need all tags as query to filter ... --->
                        <cfset tmp_test="select i_row from queryall where #tmp_where# and i_tag_name='#internal.selector_tsql[arraylen(internal.selector_tsql)].i_tag_name#'">
                        <cfquery name="test" dbtype="query" result="sq_script">
                        #PreserveSingleQuotes(tmp_test)#
                        </cfquery>
	                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfif test.recordCount neq 0>
                        	<cfif param eq ":first-child">
								<cfif ListFindNoCase(_rows,test.i_row) eq 0>
                                    <cfset _rows=ListAppend(_rows,test.i_row)>
                                </cfif>
                            <cfelseif param eq ":only-child">
                            	<cfif test.recordCount eq 1>
                                	<cfset _rows=ListAppend(_rows,test.i_row)>
                                </cfif>
                            <cfelse>
								<cfif ListFindNoCase(_rows,test.i_row[test.recordCount]) eq 0>
                                    <cfset _rows=ListAppend(_rows,test.i_row[test.recordCount])>
                                </cfif>
                            </cfif>
                        </cfif>
                    </cfloop>
                    <cfif listlen(_rows) gt 0>
                    	<cfquery name="resp" dbtype="query" result="sq_script">
                        select * from queryall where i_row in (#_rows#)
                        </cfquery>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfelse>
                    	<cfset resp=QueryNew(base.columnList)>
                        <cfset queryall="">
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <!--- content filters: (empty,parent) --->
                <cfcase value=":empty">
                	<!---<cfif ListContains(base.columnList,"value")>
                    	<!--- the word 'value' is a reserved sql word, but here is an attribute... --->
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where (_content='' and i_tag_end<>'') or (_tag_end='' and _value='')
                        </cfquery>
                    <cfelse>--->
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where _content=''
                        </cfquery>
                    <!---</cfif>--->
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":parent">
					<!--- inverse of :empty filter, but only within _content --->
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_content<>''
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <!--- form filters: (button,checkbox,checked,selected,disabled,enabled,input) --->
                <cfcase value=":button">
                	<cfif ListContains(base.columnList,"type")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(i_tag_name)='button' or LOWER(type)='button'
                        </cfquery>
                    <cfelse>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(i_tag_name)='button'
                        </cfquery>
                    </cfif>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":checkbox">
                	<cfif ListContains(base.columnList,"type")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(type)='checkbox'
                        </cfquery>
	                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfelse>
                    	<cfset resp=QueryNew(base.columnList)><!--- no type attribute exists and required, so return empty --->
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":checked">
                	<cfif ListContains(base.columnList,"checked")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(checked)='checked'
                        </cfquery>
	                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfelse>
                    	<cfset resp=QueryNew(base.columnList)><!--- no checked attribute exists and required, so return empty --->
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":selected">
                	<cfif ListContains(base.columnList,"selected")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(selected)='selected'
                        </cfquery>
	                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfelse>
                    	<cfset resp=QueryNew(base.columnList)><!--- no selected attribute exists and required, so return empty --->
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":disabled">
                	<cfif ListContains(base.columnList,"disabled")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(disabled)='disabled' or LOWER(i_tag_start) like '% disabled%'
                        </cfquery>
	                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfelse>
                    	<cfset resp=QueryNew(base.columnList)><!--- no disabled attribute exists and required, so return empty --->
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":enabled">
	                <cfif ListContains(base.columnList,"disabled")>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        select * from base where LOWER(disabled)='' and LOWER(i_tag_start) not like '% disabled%'
                        </cfquery>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
					<cfelse>
                    	<cfset resp=base>
                    </cfif>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfcase value=":input">
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name) in ('input','textarea','select','button')
                    </cfquery>
                    <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                    <cfset this.lastquery=resp>
                	<cfreturn this.lastquery>
                </cfcase>
                <cfdefaultcase>
                	<!--- FILTERS WITH ATTRIBUTES ---->
                    <!--- child filter: nth-child(x) --->
                	<cfif left(param,len(":nth-child(")) eq ":nth-child(" and right(param,1) eq ")">
                    	<cfset tmpnum=right(param,len(param)-len(":nth-child("))>
                        <cfset tmp_sub_param=lcase(left(tmpnum,len(tmpnum)-1))>
    					<!--- VERY SIMILAR TO FIRST-CHILD AND LAST-CHILD --->
						<cfset queryall=internal.base_tag>
                        <!--- extract current tsql script where clause --->
                        <cfset tsql_current=internal.sqlscript[arraylen(internal.sqlscript)].sql>
                        <cfset t_where=""><cfset tw_where="">
                        <cfif tsql_current contains "where">
                            <cfset t_where=Right(tsql_current,len(tsql_current)-FindNoCase("where",tsql_current)+1)>
                            <cfset tw_where=right(t_where,len(t_where)-5)>
                        </cfif>
                        <!--- get parent of current query --->
                        <cfif arraylen(internal.selector_tsql) gt 1>
                            <cfset base=internal.selector_tsql[arraylen(internal.selector_tsql)-1]>
                        <cfelse>
                            <!--- no parents.. so we want to search all tags --->
                            <cfset base=queryall>
                        </cfif>
                        <cfset _rows="">
                        <cfloop index="wfc" from="1" to="#base.recordcount#" step="+1">
                            <cfset tmp_begin=base.i_begin[wfc]>
                            <cfset tmp_end=base.i_end[wfc]>
                            <cfset tmp_where="i_begin>#tmp_begin# and i_end<#tmp_end# and #tw_where#">
                            <!--- we use queryall query here, because we need all tags as query to filter ... --->
							<!--- 18/12/2010 :: I KNOW THIS IS NOT THE BEST OPTIMIZED QUERY.. but works fine... if you can, improve it, but test it all. --->
                            <cfset tmp_test="select i_row from queryall where #tmp_where# and i_tag_name='#internal.selector_tsql[arraylen(internal.selector_tsql)].i_tag_name#'"><!--- i_tag_name needed here, because parent doesnt where tagname --->
                            <cfquery name="test" dbtype="query" result="sq_script">
                            #PreserveSingleQuotes(tmp_test)#
                            </cfquery>
                            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                            <cfif test.recordCount neq 0>
                            	<!--- this is the place where it is diferent from first-child and last-child --->
                                <cfif tmp_sub_param eq "even">
									<cfloop query="test">
                                    	<cfif test.currentRow mod 2 eq 0><!--- only even records --->
											<cfif ListFindNoCase(_rows,test.i_row) eq 0>
                                                <cfset _rows=ListAppend(_rows,test.i_row)>
                                            </cfif>
                                        </cfif>
                                    </cfloop>
                                <cfelseif tmp_sub_param eq "odd">
									<cfloop query="test">
                                    	<cfif test.currentRow mod 2 neq 0><!--- only odd records --->
											<cfif ListFindNoCase(_rows,test.i_row) eq 0>
                                                <cfset _rows=ListAppend(_rows,test.i_row)>
                                            </cfif>
                                        </cfif>
                                    </cfloop>
                                <cfelseif IsNumeric(tmp_sub_param)>
                                	<cfif test.recordCount gte tmp_sub_param><!--- only add row if nth position exists --->
										<cfif ListFindNoCase(_rows,test.i_row[tmp_sub_param]) eq 0>
                                            <cfset _rows=ListAppend(_rows,test.i_row[tmp_sub_param])>
                                        </cfif>
                                    </cfif>
                                </cfif>
                            </cfif>
                        </cfloop>
                        <cfif listlen(_rows) gt 0>
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from queryall where i_row in (#_rows#)
                            </cfquery>
                            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfelse>
                            <cfset resp=QueryNew(base.columnList)>
                            <cfset queryall="">
                        </cfif>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
	                	<!--- adicional checks --->
                    <!--- content filter: (contains) ---->
                    <cfelseif left(param,10) eq ":contains(" and right(param,1) eq ")"><!--- :contains(x) --->
                    	<cfset tmpnum=right(param,len(param)-10)>
                        <cfset tmpnum=left(tmpnum,len(tmpnum)-1)>
                        <cfif internal.set_casesensitive>
	                        <cfset tmpsql="select * from base where i_content like '%#tmpnum#%'">
                        <cfelse>
	                        <cfset tmpsql="select * from base where LOWER(i_content) like '%#lcase(tmpnum)#%'">
                        </cfif>
                        <cfquery name="resp" dbtype="query" result="sq_script">
                        #PreserveSingleQuotes(tmpsql)#
                        </cfquery>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                        
                    <!--- basic filters: (eq, neq, gt, lt, not) --->
                    <cfelseif left(param,4) eq ":eq(" and right(param,1) eq ")"><!--- :eq(x) --->
                    	<cfset tmpnum=right(param,len(param)-4)>
                        <cfset tmpnum=left(tmpnum,len(tmpnum)-1)>
                        <cfif base.recordCount lt tmpnum>
                        	<!--- the requested number is greater than the available values ... --->
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row=-1
                            </cfquery>
                        <cfelse>
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row=#base.i_row[tmpnum]#
                            </cfquery>                        
                        </cfif>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                    <cfelseif left(param,5) eq ":neq(" and right(param,1) eq ")"><!--- :neq(x) --->
                    	<cfset tmpnum=right(param,len(param)-5)>
                        <cfset tmpnum=left(tmpnum,len(tmpnum)-1)>
                        <cfif base.recordCount gt tmpnum>
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row<>#base.i_row[tmpnum]#
                            </cfquery>
                        <cfelse>
                        	<!--- if tmpnum is greater than base recordcounts, its always true--->
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row<>-1
                            </cfquery>
                        </cfif>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                    <cfelseif left(param,4) eq ":gt(" and right(param,1) eq ")"><!--- :gt(x) --->
                    	<cfset tmpnum=right(param,len(param)-4)>
                        <cfset tmpnum=left(tmpnum,len(tmpnum)-1)>
                        <cfif tmpnum gt base.recordCount>
                        	<!--- if the requested number is greater than the available records (no results is the answer) ... --->
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row=-1
                            </cfquery>                        
                        <cfelse>
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where i_row>#base.i_row[tmpnum]#
                            </cfquery>
                        </cfif>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                    <cfelseif left(param,4) eq ":lt(" and right(param,1) eq ")"><!--- :lt(x) --->
                    	<cfset tmpnum=right(param,len(param)-4)>
                        <cfset tmpnum=left(tmpnum,len(tmpnum)-1)>
                        <cfif tmpnum gt base.recordCount>
                        	<!--- if the requested number is greater than the available records (always true) --->
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base
                            </cfquery>
                        <cfelse>
                            <cfquery name="resp" dbtype="query" result="sq_script">
                            select * from base where #base.i_row[tmpnum]#>_row
                            </cfquery>
                        </cfif>
                        <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                    <cfelseif left(param,5) eq ":not(" and right(param,1) eq ")"><!--- :not(selector) (NOT WORKING PROPERTLY) --->
                    	<cfset tmpsel=right(param,len(param)-5)>
                        <cfset tmpsel=left(tmpsel,len(tmpsel)-1)>
                        <!--- process not selector --->
                        <cfset resp=selectorHelperNot(base,tmpsel)>
                        <!--- end not selector --->
                        <cfset this.lastquery=resp>
                        <cfreturn this.lastquery>
                    </cfif>
                </cfdefaultcase>
            </cfswitch>
            
        <cfelse>
        	<cfthrow type="sparser2.cfc" message="You must first call method getAllTags or selector."/>
        </cfif>
    </cffunction>

	<!--- called from selectorHelperMain --->
 	<cffunction name="selectorHelper" access="private" output="no" hint="Helper">
    	<cfargument name="query" required="yes" type="query" default="" hint="Query."/>
    	<cfargument name="parameter" required="yes" type="string" default="" hint="Selector."/>
    	<cfargument name="applyfilter" required="no" type="boolean" default="true" hint="Apply existing filter if exists."/>
        <cfset base=arguments.query>
        <cfif listlen(arguments.parameter,":") gt 1>
        	<cfset selecto=ListFirst(arguments.parameter,":")>
            <cfset filtro=ListLast(arguments.parameter,":")><!--- _filter(x) --->
        <cfelse>
        	<cfset selecto=arguments.parameter>
            <cfset filtro="">
        </cfif>
        <!--- segment attribute filter --->
        <cfif selecto contains "[" and selecto contains "]">
        	<cfset selecto_a=ListFirst(selecto,"[")>
            <cfset atribo=ReplaceNoCase(selecto,selecto_a,"")>
            <cfset selecto=selecto_a>
        <cfelse>
        	<cfset atribo="">
        </cfif>
       	<!--- UnEscape 'encoded \\chars' --->
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat(" ","utf-8")," ","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("=","utf-8"),"=","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("""","utf-8"),"""","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("[","utf-8"),"[","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("]","utf-8"),"]","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("$","utf-8"),"$","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("^","utf-8"),"^","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("*","utf-8"),"*","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat(":","utf-8"),":","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("!","utf-8"),"!","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("(","utf-8"),"(","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat(")","utf-8"),")","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("##","utf-8"),"##","ALL")>
        <cfset selecto=ReplaceNoCase(selecto,URLEncodedFormat("%","utf-8"),"%","ALL")>
       	<!--- UnEscape 'encoded \\chars' in attribute filter --->
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(" ","utf-8")," ","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("=","utf-8"),"=","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("""","utf-8"),"""","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("[","utf-8"),"[","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("]","utf-8"),"]","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("$","utf-8"),"$","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("^","utf-8"),"^","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("*","utf-8"),"*","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(":","utf-8"),":","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("!","utf-8"),"!","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("(","utf-8"),"(","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(")","utf-8"),")","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("##","utf-8"),"##","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("%","utf-8"),"%","ALL")>
        <!---<cfset this.debug_selecto=selecto><cfset this.debug_atribo=atribo><cfset this.debug_filtro=filtro>--->
		<!--- CHECKS --->
		<cfif left(trim(selecto),1) eq "##">
            <!--- #identifier: Finds all elements with ID of identifier --->
            <cfset tmp=right(trim(selecto),len(trim(selecto))-1)>
            <!--- check that columnlist contains id, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"id") neq 0>
            	<cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where id='#tmp#'
                    </cfquery>
                <cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(id)='#lcase(tmp)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif left(trim(selecto),1) eq ".">
            <!--- .className: Finds all elements that have class attribute with the value of className --->
            <cfset tmp=right(trim(selecto),len(trim(selecto))-1)>
            <!--- check that columnlist contains class, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0>
	            <cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where class='#tmp#' or class like '% #tmp#' or class like '% #tmp# %' or class like '#tmp# %'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(class)='#lcase(tmp)#' or LOWER(class) like '% #tmp#' or LOWER(class) like '% #tmp# %' or LOWER(class) like '#tmp# %'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains ".">
            <!--- tag.className: Gets elements of type tag that have a class attribute with the value of className --->
            <cfset tmp_tag=listfirst(trim(selecto),".")>
            <cfset tmp_class=listlast(trim(selecto),".")>
            <!--- check that columnlist contains class, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0>
	            <cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_tag_name='#tmp_tag#' and class='#tmp_class#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name)='#lcase(tmp_tag)#' and LOWER(class)='#lcase(tmp_class)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains "." and selecto contains "##">
            <!--- tag#id.className: Retreives the tag element that has an ID of id and a class attribute with the value of className --->
            <cfset tmp_tag=listfirst(trim(selecto),".")>
            <cfset tmp_id=ListLast(tmp_tag,"##")>
            <cfset tmp_tag=ListFirst(tmp_tag,"##")>
            <cfset tmp_class=ListLast(trim(selecto),".")>
            <!--- check that columnlist contains class and id, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0 and ListFindNoCase(base.columnlist,"id") neq 0>
				<cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_tag_name='#tmp_tag#' and id='#tmp_id#' and class='#tmp_class#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name)='#lcase(tmp_tag)#' and LOWER(id)='#lcase(tmp_id)#' and LOWER(class)='#lcase(tmp_class)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains "##">
            <!--- tag#id: Retreives the tag element that has an ID of id --->
            <cfset tmp_id=ListLast(selecto,"##")>
            <cfset tmp_tag=ListFirst(selecto,"##")>
            <!--- check that columnlist contains class and id, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"id") neq 0>
				<cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_tag_name='#tmp_tag#' and id='#tmp_id#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name)='#lcase(tmp_tag)#' and LOWER(id)='#lcase(tmp_id)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains "*" or left(selecto,1) eq ":"><!--- so here we support selector(":filter") without defining first a selector --->
            <!--- *: Finds all of the elements on the page --->
            <cfquery name="resp" dbtype="query" result="sq_script">
            select * from base
            </cfquery>
            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfif left(selecto,1) eq ":">
            	<cfset filtro=selecto>
            </cfif>
        <cfelse>
            <!--- tagname: Finds all elements that are named tagname --->
            <cfif internal.set_casesensitive>
                <cfquery name="resp" dbtype="query" result="sq_script">
                select * from base where i_tag_name='#trim(selecto)#'
                </cfquery>
			<cfelse>
                <cfquery name="resp" dbtype="query" result="sq_script">
                select * from base where LOWER(i_tag_name)='#lcase(trim(selecto))#'
                </cfquery>
            </cfif>
            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
        </cfif>
        
        <!--- check to see if we need to apply attribute filtering [] --->
        <cfif atribo neq "" and resp.recordCount neq 0>
        	<cfset where_clause="">
            <cfset atribo=ReplaceNoCase(atribo,"][","],[","ALL")>
            <cfset req_columns="">
            <!--- [a][b] => [a],[b] = wAtribo(1) = [a] = wAtribo(2) = [b] --->
            <cfloop index="wAtribo" list="#atribo#" delimiters=",">
                <cfset new_where="">
            	<cfset condition=ReplaceNoCase(wAtribo,"[","")>
                <cfset condition=ReplaceNoCase(condition,"]","")>
                <cfif listlen(condition,"=") gt 1><!--- [param=value] --->
					<cfset tmp_name=ListFirst(condition,"=")>
					<!--- start: reserved SQL words --->
					<!--- if attribo is a reserved SQL word prepend the char _ --->
                    <cfloop index="wSelAtE" list="#internal.sql_escape_attributes#">
                        <cfif lcase(wSelAtE) eq lcase(tmp_name)>
                            <cfset tmp_name="i_" & tmp_name>
                        </cfif>
                    </cfloop>
					<!--- end: reserved SQL words --->
                    <cfset tmp_value=ListLast(condition,"=")>
                    <cfset tmp_operator=right(tmp_name,1)>
                    <cfif not ListContains("!,^,$,*,~",tmp_operator)><cfset tmp_operator=""><cfelse><cfset tmp_name=left(tmp_name,len(tmp_name)-1)></cfif>
                    <cfif ListFindNoCase(req_columns,tmp_name) eq 0><cfset req_columns=ListAppend(req_columns,tmp_name)></cfif>
                    <!--- process and build where_clause --->
					<cfif internal.set_casesensitive eq false>
                    	<cfset tmp_name="LOWER(" & tmp_name & ")">
                        <cfset tmp_value=lcase(tmp_value)>
                    </cfif>
                    <cfswitch expression="#tmp_operator#">
                        <cfcase value="!"><!--- attribute exists and is not value --->
                            <cfset new_where=tmp_name & " <>'" & tmp_value & "' AND " & tmp_name & " <>''">
                        </cfcase>
                        <cfcase value="^"><!--- attribute starts with value --->
                            <cfset new_where=tmp_name & " like '" & lcase(tmp_value) & "%'">
                        </cfcase>
                        <cfcase value="$"><!--- attribute ends with value --->
                            <cfset new_where=tmp_name & " like '%" & tmp_value & "'">
                        </cfcase>
                        <cfcase value="*"><!--- attribute contains value --->
                            <cfset new_where=tmp_name & " like '%" & tmp_value & "%'">
                        </cfcase>
                        <cfcase value="~"><!--- attribute contains value delimited by a space --->
                            <cfset new_where=tmp_name & " like '% " & tmp_value & " %'">
                        </cfcase>
                        <cfcase value="|"><!--- attribute eq value or starts with value and an hyphen (-) --->
                            <cfset new_where=tmp_name & "='" & tmp_value & "' OR " & tmp_name & " like '" & tmp_value & "-'">
                        </cfcase>
                        <cfdefaultcase><!--- attribute equals value --->
                            <cfset new_where=tmp_name & "='" & tmp_value & "'">
                        </cfdefaultcase>
                    </cfswitch>
				<cfelse>
                	<!--- [param] --->
                    <cfset tmp_name=condition>
					<!--- start: reserved SQL words --->
					<!--- if attribo is a reserved SQL word prepend the char _ --->
                    <cfloop index="wSelAtE" list="#internal.sql_escape_attributes#">
                        <cfif lcase(wSelAtE) eq lcase(tmp_name)>
                            <cfset tmp_name="i_" & tmp_name>
                        </cfif>
                    </cfloop>
					<!--- end: reserved SQL words --->
                    <cfif ListFindNoCase(req_columns,tmp_name) eq 0><cfset req_columns=ListAppend(req_columns,tmp_name)></cfif>
                    <cfset new_where=tmp_name & " <>''">
                </cfif>
                <!--- add to where_clause --->
                <cfif where_clause neq "">
                	<cfset where_clause=where_clause & " AND " & new_where>
                <cfelse>
                	<cfset where_clause=new_where>
                </cfif>
            </cfloop>
            <!--- check that all required attributes do exist in base.columnList, or else return and empty query (can only be if attribute name doesnt exist in code) --->
			<cfset all_req_attributes_exist=true>
            <cfset base_col=resp.columnList>
            <cfloop index="wAt" list="#req_columns#">
            	<cfif ListFindNoCase(base_col,wAt) eq 0>
                	<cfset all_req_attributes_exist=false>
                </cfif>
            </cfloop>
            <!--- else run sub-query --->
            <cfif all_req_attributes_exist>
            	<cfset tmp_q="select * from resp where " & trim(where_clause)>
            	<cfquery name="respb" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(tmp_q)#
                </cfquery>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <cfset resp=respb>
				<!--- for debug only 
                <cfset this.last_sql=tmp_q>--->
            <cfelse>
            	<cfset resp=QueryNew(base_col)>
				<!--- for debug only
                <cfset this.last_sql="">--->
            </cfif>
        </cfif>

        <cfset internal.selector_tsql[arraylen(internal.selector_tsql)+1]=resp><!--- this is needed here, because _filter(x) uses it inside! --->
        <cfset this.lastquery=resp><!--- this is needed here, because _filter(x) uses it inside! --->
        <!--- apply filter lastquery --->
		<cfif filtro neq "" and arguments.applyfilter>
        	<cfset resp=_filter(filtro)>
			<cfset this.lastquery=resp><!--- this is needed here, because after filter must be available for other selectors! --->
            <cfset internal.selector_tsql[arraylen(internal.selector_tsql)+1]=resp><!--- this is needed here, because after filter must be available for other selectors! --->
        </cfif>
        <cfset internal.filters[arraylen(internal.filters)+1]=filtro>
        <cfreturn resp/>
    </cffunction>
    <!--- --->
<cffunction name="selectorHelperNot" access="private" output="no" hint="Helper Not selector">
    	<cfargument name="query" required="yes" type="query" default="" hint="Query."/>
    	<cfargument name="parameter" required="yes" type="string" default="" hint="Selector."/>
    	<cfargument name="applyfilter" required="no" type="boolean" default="true" hint="Apply existing filter if exists."/>
        <cfset base=arguments.query>
        <cfif listlen(arguments.parameter,":") gt 1>
        	<cfset selecto=ListFirst(arguments.parameter,":")>
            <cfset filtro=ListLast(arguments.parameter,":")><!--- _filter(x) --->
        <cfelse>
        	<cfset selecto=arguments.parameter>
            <cfset filtro="">
        </cfif>
        <!--- segment attribute filter --->
        <cfif selecto contains "[" and selecto contains "]">
        	<cfset selecto_a=ListFirst(selecto,"[")>
            <cfset atribo=ReplaceNoCase(selecto,selecto_a,"")>
            <cfset selecto=selecto_a>
        <cfelse>
        	<cfset atribo="">
        </cfif>
       	<!--- UnEscape 'encoded \\chars' --->
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat(" ","utf-8")," ","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("=","utf-8"),"=","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("""","utf-8"),"""","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("[","utf-8"),"[","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("]","utf-8"),"]","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("$","utf-8"),"$","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("^","utf-8"),"^","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("*","utf-8"),"*","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat(":","utf-8"),":","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("!","utf-8"),"!","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("(","utf-8"),"(","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat(")","utf-8"),")","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("##","utf-8"),"##","ALL")>
        <cfset arguments.parameter=ReplaceNoCase(arguments.parameter,URLEncodedFormat("%","utf-8"),"%","ALL")>
       	<!--- UnEscape 'encoded \\chars' in attribute filter --->
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(" ","utf-8")," ","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("=","utf-8"),"=","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("""","utf-8"),"""","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("[","utf-8"),"[","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("]","utf-8"),"]","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("$","utf-8"),"$","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("^","utf-8"),"^","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("*","utf-8"),"*","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(":","utf-8"),":","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("!","utf-8"),"!","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("(","utf-8"),"(","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat(")","utf-8"),")","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("##","utf-8"),"##","ALL")>
        <cfset atribo=ReplaceNoCase(atribo,URLEncodedFormat("%","utf-8"),"%","ALL")>
        <!---<cfset this.debug_selecto=selecto><cfset this.debug_atribo=atribo><cfset this.debug_filtro=filtro>--->
		<!--- CHECKS --->
		<cfif left(trim(selecto),1) eq "##">
            <!--- #identifier: Finds all elements with ID of identifier --->
            <cfset tmp=right(trim(selecto),len(trim(selecto))-1)>
            <!--- check that columnlist contains id, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"id") neq 0>
            	<cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where id<>'#tmp#'
                    </cfquery>
                <cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(id)<>'#lcase(tmp)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif left(trim(selecto),1) eq ".">
            <!--- .className: Finds all elements that have class attribute with the value of className --->
            <cfset tmp=right(trim(selecto),len(trim(selecto))-1)>
            <!--- check that columnlist contains class, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0>
	            <cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where class<>'#tmp#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(class)<>'#lcase(tmp)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains ".">
            <!--- tag.className: Gets elements of type tag that have a class attribute with the value of className --->
            <cfset tmp_tag=listfirst(trim(selecto),".")>
            <cfset tmp_class=listlast(trim(selecto),".")>
            <!--- check that columnlist contains class, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0>
	            <cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_tag_name<>'#tmp_tag#' and class<>'#tmp_class#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name)<>'#lcase(tmp_tag)#' and LOWER(class)<>'#lcase(tmp_class)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains "." and selecto contains "##">
            <!--- tag#id.className: Retreives the tag element that has an ID of id and a class attribute with the value of className --->
            <cfset tmp_tag=listfirst(trim(selecto),".")>
            <cfset tmp_id=ListLast(tmp_tag,"##")>
            <cfset tmp_tag=ListFirst(tmp_tag,"##")>
            <cfset tmp_class=ListLast(trim(selecto),".")>
            <!--- check that columnlist contains class and id, if not return a querynew object --->
            <cfif ListFindNoCase(base.columnlist,"class") neq 0 and ListFindNoCase(base.columnlist,"id") neq 0>
				<cfif internal.set_casesensitive>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where i_tag_name<>'#tmp_tag#' and id<>'#tmp_id#' and class<>'#tmp_class#'
                    </cfquery>
				<cfelse>
                    <cfquery name="resp" dbtype="query" result="sq_script">
                    select * from base where LOWER(i_tag_name)<>'#lcase(tmp_tag)#' and LOWER(id)<>'#lcase(tmp_id)#' and LOWER(class)<>'#lcase(tmp_class)#'
                    </cfquery>
                </cfif>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
            <cfelse>
                <cfset resp=QueryNew("")>
            </cfif>
        <cfelseif selecto contains "*">
            <!--- *: Finds all of the elements on the page --->
            <cfquery name="resp" dbtype="query" result="sq_script">
            select * from base
            </cfquery>
            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
        <cfelse>
            <!--- tagname: Finds all elements that are named tagname --->
            <cfif internal.set_casesensitive>
                <cfquery name="resp" dbtype="query" result="sq_script">
                select * from base where i_tag_name<>'#trim(selecto)#'
                </cfquery>
			<cfelse>
                <cfquery name="resp" dbtype="query" result="sq_script">
                select * from base where LOWER(i_tag_name)<>'#lcase(trim(selecto))#'
                </cfquery>
            </cfif>
            <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
        </cfif>
        
        <!--- check to see if we need to apply attribute filtering [] --->
        <cfif atribo neq "" and resp.recordCount neq 0>
        	<cfset where_clause="">
            <cfset atribo=ReplaceNoCase(atribo,"][","],[","ALL")>
            <cfset req_columns="">
            <!--- [a][b] => [a],[b] = wAtribo(1) = [a] = wAtribo(2) = [b] --->
            <cfloop index="wAtribo" list="#atribo#" delimiters=",">
                <cfset new_where="">
            	<cfset condition=ReplaceNoCase(wAtribo,"[","")>
                <cfset condition=ReplaceNoCase(condition,"]","")>
                <cfif listlen(condition,"=") gt 1><!--- [param=value] --->
					<cfset tmp_name=ListFirst(condition,"=")>
                    <cfset tmp_value=ListLast(condition,"=")>
                    <cfset tmp_operator=right(tmp_name,1)>
                    <cfif not ListContains("!,^,$,*,~",tmp_operator)><cfset tmp_operator=""><cfelse><cfset tmp_name=left(tmp_name,len(tmp_name)-1)></cfif>
                    <cfif ListFindNoCase(req_columns,tmp_name) eq 0><cfset req_columns=ListAppend(req_columns,tmp_name)></cfif>
                    <!--- process and build where_clause --->
					<cfif internal.set_casesensitive eq false>
                    	<cfset tmp_name="LOWER(" & tmp_name & ")">
                        <cfset tmp_value=lcase(tmp_value)>
                    </cfif>
                    <cfswitch expression="#tmp_operator#">
                        <cfcase value="!"><!--- attribute exists and is not value --->
                            <cfset new_where=tmp_name & " ='" & tmp_value & "' AND " & tmp_name & " <>''">
                        </cfcase>
                        <cfcase value="^"><!--- attribute starts with value --->
                            <cfset new_where=tmp_name & " not like '" & lcase(tmp_value) & "%'">
                        </cfcase>
                        <cfcase value="$"><!--- attribute ends with value --->
                            <cfset new_where=tmp_name & " not like '%" & tmp_value & "'">
                        </cfcase>
                        <cfcase value="*"><!--- attribute contains value --->
                            <cfset new_where=tmp_name & " not like '%" & tmp_value & "%'">
                        </cfcase>
                        <cfcase value="~"><!--- attribute contains value --->
                            <cfset new_where=tmp_name & " not like '% " & tmp_value & " %'">
                        </cfcase>
                        <cfdefaultcase><!--- attribute equals value --->
                            <cfset new_where=tmp_name & "<>'" & tmp_value & "'">
                        </cfdefaultcase>
                    </cfswitch>
				<cfelse>
                	<!--- [param] --->
                    <cfset tmp_name=condition>
                    <cfif ListFindNoCase(req_columns,tmp_name) eq 0><cfset req_columns=ListAppend(req_columns,tmp_name)></cfif>
                    <cfset new_where=tmp_name & " =''">
                </cfif>
                <!--- add to where_clause --->
                <cfif where_clause neq "">
                	<cfset where_clause=where_clause & " AND " & new_where>
                <cfelse>
                	<cfset where_clause=new_where>
                </cfif>
            </cfloop>
            <!--- check that all required attributes do exist in base.columnList, or else return and empty query (can only be if attribute name doesnt exist in code) --->
			<cfset all_req_attributes_exist=true>
            <cfset base_col=resp.columnList>
            <cfloop index="wAt" list="#req_columns#">
            	<cfif ListFindNoCase(base_col,wAt) eq 0>
                	<cfset all_req_attributes_exist=false>
                </cfif>
            </cfloop>
            <!--- else run sub-query --->
            <cfif all_req_attributes_exist>
            	<cfset tmp_q="select * from resp where " & trim(where_clause)>
            	<cfquery name="respb" dbtype="query" result="sq_script">
                #PreserveSingleQuotes(tmp_q)#
                </cfquery>
                <cfset internal.sqlscript[arraylen(internal.sqlscript)+1]=sq_script>
                <cfset resp=respb>
				<!--- for debug only 
                <cfset this.last_sql=tmp_q>--->
            <cfelse>
            	<cfset resp=QueryNew(base_col)>
				<!--- for debug only
                <cfset this.last_sql="">--->
            </cfif>
        </cfif>
                
        <cfset internal.selector_tsql[arraylen(internal.selector_tsql)+1]=resp><!--- this is needed here, because _filter(x) uses it inside! --->
        <cfset this.lastquery=resp><!--- this is needed here, because _filter(x) uses it inside! --->
        <!--- apply filter lastquery --->
		<cfif filtro neq "" and arguments.applyfilter>
        	<cfset resp=_filter(filtro)>
			<cfset this.lastquery=resp><!--- this is needed here, because after filter must be available for other selectors! --->
            <cfset internal.selector_tsql[arraylen(internal.selector_tsql)+1]=resp><!--- this is needed here, because after filter must be available for other selectors! --->
        </cfif>        
        <cfset internal.filters[arraylen(internal.filters)+1]=filtro>
        
        <cfreturn resp/>
    </cffunction>
    <!--- 6/3/2012 psb --->
	<!--- findSelector(type,value,src) --->
    <cffunction name="findSelector" returntype="struct" output="no" hint="returns array with suggested css selector's for finding the given value." access="public">
        <cfargument name="type" type="string" required="yes" hint="suggested type of value" default="partial"/>
        <cfargument name="fvalue" type="string" required="yes" hint="value to be find" default=""/>
        <!---<cfargument name="src" type="string" required="no" hint="src" default=""/>--->
        <cfset toreturn=StructNew()>
        <cfset el_selector="">
        <!---<cfif not isDefined("internal")>
            <cfset object=CreateObject("component","base.apis.sparser2")>
            <cfset parser=object.init(arguments.src)>
            <cfset internal=StructNew()>
            <cfset internal.base_tag=parser.selector("*").query()>
        </cfif>--->
        <!--- filter for specific preferred tag type or result position --->
        <cfset preferred_tagtype="">
        <cfset the_type=arguments.type>
        <cfif the_type contains "[">
            <cfset position=ListLast(the_type,"[")><cfset position=ReplaceNoCase(position,"]","","ALL")><cfset position=trim(position)>
            <cfif position eq ""><cfset position=1></cfif>
            <cfif not IsNumeric(position)>
                <!--- position is a preferred tag type (ex. img,h3) --->
                <cfset preferred_tagtype=position>
                <cfset position=1>
            </cfif>
            <cfset the_type=ListFirst(the_type,"[")>
        <cfelse>
            <cfset position=1>
        </cfif>
        <cfset break=false>
        <cfset value_col="i_content"><!--- column that has the content searched for --->
        <!--- find specific tag, being searched for --->
        <cfswitch expression="#the_type#">
            <cfcase value="exact,exacto,igual,identico">
                <!--- exact match (return the first result if more than one result - or the one specified (in position var) ? (another attribute perhaps?) --->
                <cfquery name="specificb" dbtype="query">
                select * from internal.base_tag where i_content='#arguments.fvalue#'
                </cfquery>
            </cfcase>
            <cfcase value="partial,parcial,contenido">
                <!--- select only those tags with i_content without tags, who have the specified value in its content (case sensitive) --->
                <cfset tst="select * from internal.base_tag where i_content not like '%<%' and i_content not like '%>%' and i_tag_name not like 'script'">
                <cfquery name="specificb" dbtype="query">
                #PreserveSingleQuotes(tst)#
                </cfquery>
                <!--- arguments.fvalue must be only within the CONTENT, without tags --->
                <cfset chosen_rows="">
                <cfloop query="specificb">
                    <cfif specificb.i_content contains "<" and specificb.i_content contains ">">
                        <!--- omit if content has tags (we process all tags so it shouldn't matter --->
                    <cfelse>
                        <cfif lcase(specificb.i_content) contains lcase(arguments.fvalue)>
                            <cfset chosen_rows=ListAppend(chosen_rows,specificb.i_row)>
                        </cfif>                
                    </cfif>
                </cfloop>
                <cfif chosen_rows eq "">
                    <cfset chosen_rows="0">
                </cfif> 
                <cfquery name="specificb" dbtype="query">
                select * from internal.base_tag where i_row in (#chosen_rows#)
                </cfquery>
            </cfcase>
            <cfcase value="partialcs,parcial sensible,contenido sensible">
                <!--- select only those tags with i_content without tags, who have the specified value in its content (case sensitive) --->
                <cfset tst="select * from internal.base_tag where i_content not like '%<%' and i_content not like '%>%' and i_tag_name not like 'script'">
                <cfquery name="specificb" dbtype="query">
                #PreserveSingleQuotes(tst)#
                </cfquery>
                <!--- arguments.fvalue must be only within the CONTENT, without tags --->
                <cfset chosen_rows="">
                <cfloop query="specificb">
                    <cfif specificb.i_content contains "<" and specificb.i_content contains ">">
                        <!--- omit if content has tags (we process all tags so it shouldn't matter --->
                    <cfelse>
                        <cfif specificb.i_content contains arguments.fvalue>
                            <cfset chosen_rows=ListAppend(chosen_rows,specificb.i_row)>
                        </cfif>
                    </cfif>
                </cfloop>
                <cfif chosen_rows eq "">
                    <cfset chosen_rows="0">
                </cfif>    
                <cfquery name="specificb" dbtype="query">
                select * from internal.base_tag where i_row in (#chosen_rows#)
                </cfquery>
            </cfcase>
            <cfcase value="similar,parecido">
                <!--- select only those tags with i_content without tags, who have the specified value the MOST similar to its content --->
                <cfset tst="select * from internal.base_tag where i_content not like '%<%' and i_content not like '%>%' and i_tag_name not like 'script'">
                <cfquery name="specificb" dbtype="query">
                #PreserveSingleQuotes(tst)#
                </cfquery>
                <!--- arguments.fvalue must similar within the CONTENT, without tags --->
                <cfset chosen_rows="">
                <cfset last_lv=100000000>
                <cfset lv_row=0>
                <cfloop query="specificb">
					<!--- calculate different percentage (consider only the most similar as the result) --->
					<cfset lv_value=levDistanceb(specificb.i_content,arguments.fvalue)>
					<!--- --->
    				<cfif lv_value lte last_lv>
                    	<cfset last_lv=lv_value>
                        <cfset lv_row=specificb.i_row>
                    </cfif>
                </cfloop>
                <cfquery name="specificb" dbtype="query">
                select * from internal.base_tag where i_row=#lv_row#
                </cfquery>
            </cfcase>
            <cfcase value="attribute,attributes,atributo,atributos">
                <!--- exact attribute --->
                <!--- search using loop --->
                <cfset cols=internal.base_tag.columnList>
                <cfloop index="qr" from="1" to="#internal.base_tag.recordCount#" step="+1">
                    <!--- for each column, search the attribute value --->
                    <cfloop index="qcol" list="#cols#">
                        <!--- exact match --->
                        <cfif Evaluate("internal.base_tag.#qcol#[qr]") eq arguments.fvalue>
                            <!--- found --->
                            <cfset the_row=Evaluate("internal.base_tag.i_row[qr]")>
                            <cfquery name="specificb" dbtype="query">
                            select * from internal.base_tag where i_row=#the_row#
                            </cfquery>
                            <cfset value_col=qcol>
                            <cfset break=true>
                            <cfbreak/>
                        </cfif>
                    </cfloop>
                    <cfif break>
                        <cfbreak/>
                    </cfif>
                </cfloop>
            </cfcase>
            <cfcase value="attributep,attributesp,atributop,atributosp,contenido de atributo,contenido en atributo,contenido atributo">
                <!--- partial attribute --->
                <!--- search using loop --->
                <cfset cols=internal.base_tag.columnList>
                <cfloop index="qr" from="1" to="#internal.base_tag.recordCount#" step="+1">
                    <!--- for each column, search the attribute value --->
                    <cfloop index="qcol" list="#cols#">
                        <!--- partial match --->
                        <cfif Evaluate("internal.base_tag.#qcol#[qr]") contains arguments.fvalue>
                            <!--- found --->
                            <cfset the_row=Evaluate("internal.base_tag.i_row[qr]")>
                            <cfquery name="specificb" dbtype="query">
                            select * from internal.base_tag where i_row=#the_row#
                            </cfquery>
                            <cfset value_col=qcol>
                            <cfset break=true>
                            <cfbreak/>
                        </cfif>
                    </cfloop>
                    <cfif break>
                        <cfbreak/>
                    </cfif>
                </cfloop>
            </cfcase>
        </cfswitch>
        <cfset chosen_position=1>
        <!--- filter specific query for preferred tagtype or result position --->
        <cfif (specificb.recordCount gt 1 or preferred_tagtype neq "") and specificb.recordCount gte position>
            <cfif preferred_tagtype neq "">
                <!--- --->
                <!--- special preferred types --->
                <cfif preferred_tagtype eq "biggest" or preferred_tagtype eq "maslargo">
                    <!--- biggest content size... choosen --->
                    <cfset biggest_row=0>
                    <cfset biggest_size=0>
                    <cfloop query="specificb">
                        <cfset test_wi_tags=removeTags(specificb.i_content)>
                        <cfif len(test_wi_tags) gte biggest_size>
                            <cfset biggest_size=len(test_wi_tags)>
                            <cfset biggest_row=specificb.i_row>
                            <cfset chosen_position=specificb.currentRow>
                        </cfif>
                    </cfloop>
                    <cfquery name="specific" dbtype="query">
                    select * from specificb where i_row=#biggest_row#
                    </cfquery>
                <cfelseif preferred_tagtype eq "smallest" or preferred_tagtype eq "mascorto">
                    <!--- smallest content size... choosen --->
                    <cfset smallest_row=0>
                    <cfset smallest_size=1000000>
                    <cfloop query="specificb">
                        <cfset test_wi_tags=removeTags(specificb.i_content)>
                        <cfif len(test_wi_tags) lte smallest_size>
                            <cfset smallest_size=len(test_wi_tags)>
                            <cfset smallest_row=specificb.i_row>
                            <cfset chosen_position=specificb.currentRow>
                        </cfif>
                    </cfloop>
                    <cfquery name="specific" dbtype="query">
                    select * from specificb where i_row=#smallest_row#
                    </cfquery>
                <cfelseif preferred_tagtype eq "similar" or preferred_tagtype eq "parecido">
                    <!--- most similar content... choosen (using levenstain distance) --->
                    <cfset lv_smallest=10000000>
                    <cfset lv_row=0>
                    <cfloop query="specificb">
                        <cfset actual=levDistanceb(specificb.i_content,arguments.fvalue)>
                        <cfif actual lte lv_smallest>
                            <cfset lv_smallest=actual>
                            <cfset lv_row=specificb.i_row>
                            <cfset chosen_position=specificb.currentRow>
                        </cfif>
                    </cfloop>
                    <cfquery name="specific" dbtype="query">
                    select * from specificb where i_row=#lv_row#
                    </cfquery>                
                <cfelse>
                    <!--- choose by tagtype --->
                    <cfquery name="specificc" dbtype="query">
                    select * from specificb where i_tag_name='#lcase(preferred_tagtype)#'
                    </cfquery>
                    <cfif specificc.recordCount gt 0>
                        <!--- return as it is --->
                        <cfquery name="specific" dbtype="query">
                        select * from specificc
                        </cfquery>
                    <cfelse>
                        <!--- search for partial result (return the first match) --->
                        <cfquery name="specific" dbtype="query">
                        select * from specificb where i_tag_name like '%#lcase(preferred_tagtype)#%'
                        </cfquery>
                    </cfif>
                </cfif>
            <cfelse>
                <cfset tmp_row=specificb.i_row[position]>
                <cfquery name="specific" dbtype="query">
                select * from specificb where i_row=#tmp_row#
                </cfquery>
                <cfset chosen_position=position>
            </cfif>
        <cfelse>
            <cfquery name="specific" dbtype="query">
            select * from specificb
            </cfquery>
        </cfif>
        <!--- --->
        <cfif specific.recordCount neq 0>
            <cfset the_tag=specific.i_tag_name>
            <cfset pos_end=specific.i_end>
            <cfset pos_begin=specific.i_begin>
            <cfset pos_irow=specific.i_row>
            <!--- search parent tags --->
            <cfset previous_sql="select * from internal.base_tag where i_end>#pos_end# and i_begin<#pos_begin#">
            <cfquery name="previous" dbtype="query">
            #PreserveSingleQuotes(previous_sql)#
            </cfquery>
            <cfloop query="previous">
                <cfset the_tag=previous.i_tag_name>
                <cfif the_tag neq "body" and the_tag neq "html">
                    <cfset el_selector=ListAppend(el_selector,the_tag," ")>
                    <cfif isDefined("previous.id") and ListFindNoCase("ul,li",the_tag) eq 0><!--- ul and li tags, should not have ids or class --->
                        <cfif previous.id neq "" and not previous.id contains " ">
                            <cfset el_selector=el_selector & "##" & previous.id> 
                        <cfelseif previous.id contains " ">
                            <cfset tmp=ReplaceNoCase(previous.id," ","\ ","ALL")>
                            <cfset el_selector=el_selector & "[id=" & tmp & "]">
                        </cfif>
                    </cfif>
                    <cfif isDefined("previous.class") and ListFindNoCase("ul,li",the_tag) eq 0><!--- ul and li tags, should not have ids or class --->
                        <cfif previous.class neq "" and not previous.class contains " ">
                            <cfset el_selector=el_selector & "." & previous.class> 
                        <cfelseif previous.class contains " ">
                            <cfset tmp=ReplaceNoCase(previous.class," ","\ ","ALL")>
                            <cfset el_selector=el_selector & "[class=" & tmp & "]">
                        </cfif>
                    </cfif>
                </cfif>
            </cfloop>
            <!--- add specific searched tag to selector --->
            <cfset el_selector=ListAppend(el_selector,specific.i_tag_name," ")>
            <cfif isDefined("specific.id") and ListFindNoCase("ul,li",the_tag) eq 0><!--- ul and li tags, should not have ids or class --->
                <cfif specific.id neq "" and not specific.id contains " ">
                    <cfset el_selector=el_selector & "##" & specific.id>
                <cfelseif specific.id contains " ">
                    <cfset tmp=ReplaceNoCase(specific.id, " ","\ ","ALL")>
                    <cfset el_selector=el_selector & "[id=" & tmp & "]">
                </cfif>
            </cfif>
            <cfif isDefined("specific.class") and ListFindNoCase("ul,li",the_tag) eq 0><!--- ul and li tags, should not have ids or class --->
                <cfif specific.class neq "" and not specific.class contains " ">
                    <cfset el_selector=el_selector & "." & specific.class>
                <cfelseif specific.class contains " ">
                    <cfset tmp=ReplaceNoCase(specific.class, " ","\ ","ALL")>
                    <cfset el_selector=el_selector & "[class=" & tmp & "]">
                </cfif>
            </cfif>
            <!--- --->
            <!--- test the found selector --->
            <!---<cfdump var="#el_selector#"/><cfabort/>--->
            <cfset test=selector(el_selector).query()>
            <!---<cfdump var="#el_selector#"/><cfdump var="#test#"/><cfabort/>--->
            <!--- if test has more than one result, search the specific i_row of the searched content to match a filter --->
            <!--- here is where types will affect results --->
            <cfif test.recordCount gt 1>
                <cfloop query="test">
                    <cfif test.i_row eq specific.i_row>
                        <cfset el_selector=el_selector & ":eq(#test.currentRow#)">
                        <cfbreak/>
                    </cfif>
                </cfloop>
                <!---<cfset test=parser.selector(the_selector).query()>--->
            </cfif>  
            <!--- --->
        </cfif>
        <!---<cfdump var="#specific#"/>--->
        <cfset toreturn.selector=el_selector>
        <cfset toreturn.value_col=value_col>
        <cfset toreturn.positions=specificb.recordCount>
        <cfset toreturn.chosen_position=chosen_position> 
        <!---
        <cfset toreturn.test=test>
        <cfset toreturn.i_row=specific.i_row>
        <cfset toreturn.i_content=specific.i_content>
        <cfset toreturn.the_type=the_type>--->
        <cfset toreturn.searchedValue=arguments.fvalue>
        <cfif arguments.fvalue neq Evaluate("specific.#value_col#")>
        	<cfset toreturn.matched=false>
		<cfelse>
        	<cfset toreturn.matched=true>
        </cfif>
        <!---
        <cfif isDefined("specificb.href")>
        	<cfset toreturn.specific_href=specificb.href>
        </cfif>--->
        <cfreturn toreturn/>
    </cffunction>
	<!--- --->
    <!--- lev_distance CFM method --->
    <cffunction name="levDistance" access="public" returntype="numeric" hint="Computes the Levenshtein distance between two strings.">
        <cfargument type="string" name="first" required="yes"/>
        <cfargument type="string" name="second" required="yes"/>
        <cfreturn levDistanceb(arguments.first,arguments.second)/>
	</cffunction>
<cfscript>
function struct2query(theArray){
	var columnNames = "";
	var columnList = "";
	var theQuery = queryNew("");
	var i=0;
	var j=0;
	if(NOT arrayLen(theArray))
		return theQuery;

	columnNames = structKeyArray(theArray[1]);
	columnList = ReplaceNoCase(arrayToList(columnNames),":","_","ALL"); //replace attribute names with : to _
	theQuery = queryNew(columnList);
	queryAddRow(theQuery, arrayLen(theArray));
	for(i=1; i LTE arrayLen(theArray); i=i+1){
		for(j=1; j LTE arrayLen(columnNames); j=j+1){
			// this is not the best way to do it!! :: skipping if column is invalid
			try {
				querySetCell(theQuery, ReplaceNoCase(columnNames[j],":","_","ALL"), theArray[i][columnNames[j]], i);
			} catch(Any e) {
			}
		}
	}
	return theQuery;
}
</cfscript>
<cfscript>
/**
* Concatenate two queries together.
* 
* @param q1      First query. (Optional)
* @param q2      Second query. (Optional)
* @return Returns a query. 
* @author Chris Dary (umbrae@gmail.com) 
* @version 1, February 23, 2006 
*/
function queryConcat(q1,q2) {
    var row = "";
    var col = "";

    if(q1.columnList NEQ q2.columnList) {
        return q1;
    }

    for(row=1; row LTE q2.recordCount; row=row+1) {
     queryAddRow(q1);
     for(col=1; col LTE listLen(q1.columnList); col=col+1)
        querySetCell(q1,ListGetAt(q1.columnList,col), q2[ListGetAt(q1.columnList,col)][row]);
    }
    return q1;
}
</cfscript>
<cfscript>
function cleanTags(txtal) {
	return trim(REReplaceNoCase(txtal,"<[^>]*>","","ALL"));
}
</cfscript>
<cfscript>
/**
* Replaces oldSubString with newSubString from a specified starting position.
*
* @param theString      The string to modify. (Required)
* @param oldSubString      The substring to replace. (Required)
* @param newSubString      The substring to use as a replacement. (Required)
* @param startIndex      Where to start replacing in the string. (Required)
* @param theScope      Number of replacements to make. Default is "ONE". Value can be "ONE" or "ALL." (Optional)
* @return Returns a string.
* @author Shawn Seley (shawnse@aol.com)
* @version 1, June 26, 2002
*/
function ReplaceAt(theString, oldSubString, newSubString, startIndex){
    var targetString = "";
    var preString = "";

    var theScope = "ONE";
    if(ArrayLen(Arguments) GTE 5) theScope = Arguments[5];

    if (startIndex LTE Len(theString)) {
        targetString = Right(theString, Len(theString)-startIndex+1);
        if (startIndex GT 1) preString = Left(theString, startIndex-1);
        return preString & Replace(targetString, oldSubString, newSubString, theScope);
    } else {
        return theString;
    }
}
</cfscript>
<cfscript>
/**
 * Computes the Levenshtein distance between two strings.
 * 
 * @param s 	 First string. (Required)
 * @param t 	 Second string. (Required)
 * @return Returns a number. 
 */
function levDistanceb(s,t) {
	var d = ArrayNew(2);
	var i = 1;
	var j = 1;
	var s_i = "A";
	var t_j = "A";
	var cost = 0;
	
	var n = len(s)+1;
	var m = len(t)+1;
	
	d[n][m]=0;
	
	if (n is 1) {
		return m;
	}
	
	if (m is 1) {
		return n;
	}
	
	 for (i = 1; i lte n; i=i+1) {
	  d[i][1] = i-1;
	}

	for (j = 1; j lte m; j=j+1) {
	  d[1][j] = j-1;
	}
	
	for (i = 2; i lte n; i=i+1) {
	  s_i = Mid(s,i-1,1);

	  for (j = 2; j lte m; j=j+1) {
		t_j = Mid(t,j-1,1);

		if (s_i is t_j) {
		  cost = 0;
		}
		else {
		  cost = 1;
		}
		d[i][j] = min(d[i-1][j]+1, d[i][j-1]+1);
		d[i][j] = min(d[i][j], d[i-1][j-1] + cost);
	  }
	}
	
	return d[n][m];
}
</cfscript>
</cfcomponent>