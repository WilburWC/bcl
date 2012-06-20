<--- --------------------------------------------------------------------------------------- ----
	
	Blog Entry:
	PatternMatcher.cfc - A ColdFusion Component Wrapper For The Java Regular Expression Engine
	
	Author:
	Ben Nadel / Kinky Solutions
	
	Link:
	http://www.bennadel.com/index.cfm?event=blog.view&id=2097
	
	Date Posted:
	Jan 18, 2011 at 10:14 AM
	
---- --------------------------------------------------------------------------------------- --->


<cfcomponent output="false" hint="I provide easier, implicitly type-cast access to the underlying Java Pattern and Matcher functionality.">
 	<cffunction name="init" access="public" returntype="any" output="false" hint="I return an intialized component.">
 		<!--- Define arguments. --->
		<cfargument name="pattern" type="string" required="true" hint="I am the Java-compatible regular expression to be used to create this pattern matcher." />
 		<cfargument name="input" type="string" required="true" hint="I am the input text over which we will be matching the above regular expression pattern." />
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Store the original values. --->
		<cfset variables.pattern = arguments.pattern />
		<cfset variables.input = arguments.input />
 
		<!--- Compile the regular expression pattern and get the matcher for the given input sequence. --->
		<cfset variables.matcher = createObject( "java", "java.util.regex.Pattern" ).compile( javaCast( "string", variables.pattern ) ).matcher( javaCast( "string", variables.input ) ) />
 
		<!--- Create a buffer to store the replacement result. --->
		<cfset variables.buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
 
		<!--- Return this object reference for method chaining. --->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction name="find_" access="public" returntype="boolean" output="false" hint="I attempt to find the next pattern match located within the input string.">
 		<!--- Pass this request onto the matcher. --->
		<cfreturn variables.matcher.find() />
	</cffunction>
 
 
	<cffunction name="group" access="public" returntype="any" output="false" hint="I return the value captured by the given group. NOTE: Zero (0) will return the entire pattern match.">
		<!--- Define arguments. --->
		<cfargument name="index" type="numeric" required="false" default="0" />
 		<cfargument name="default" type="string" required="false" hint="I am the optional default to use if the given group (index) was not captured. Non-captured group references will return VOID. A default can be used to return non-void values."/>
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Get the given group value. --->
		<cfset local.capturedValue = variables.matcher.group(javaCast( "int", arguments.index )) />
 
		<!--- Check to see if the given group was able to capture a value (of if it did not, in which case, it will return NULL, destroying the variable). --->
		<cfif structKeyExists( local, "capturedValue" )>
 			<!--- Return the captured value. --->
			<cfreturn local.capturedValue />
 		<cfelseif structKeyExists( arguments, "default" )>
 			<!--- No group was captured, but a default value was provided. Return the default value. --->
			<cfreturn arguments.default />
 		<cfelse>
 			<!--- No value was captured and no default was provided; simply return VOID to the calling context. --->
			<cfreturn />
 		</cfif>
	</cffunction>
 
 
	<cffunction name="groupCount" access="public" returntype="numeric" output="false" hint="I return the number of capturing groups within the regular exression pattern.">
 		<!--- Pass this request onto the matcher. --->
		<cfreturn variables.matcher.groupCount() />
	</cffunction>
 
 
	<cffunction name="hasGroup" access="public" returntype="any" output="false" hint="I determine whether or not the given group was captured in the previous match.">
 		<!--- Define arguments. --->
		<cfargument name="index" type="numeric" required="true" />
 
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Get the given group value. --->
		<cfset local.capturedValue = variables.matcher.group(javaCast( "int", arguments.index )) />
 
		<!--- Return whether or not the given captured group exists. If it was captured, the value will exists; if it was not captured, the given group value will be NULL (and hence not exist). --->
		<cfreturn structKeyExists( local, "capturedValue" ) />
	</cffunction>
 
 
	<cffunction name="match" access="public" returntype="array" output="false" hint="I return the collection of all pattern matches found within the given input. NOTE: This resets the internal matcher.">
		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Reset the pattern matcher. --->
		<cfset this.reset() />
 
		<!--- Create an array in which to hold the aggregated pattern matches. --->
		<cfset local.matches = [] />
 
		<!--- Keep looping, looking for matches. --->
		<cfloop condition="variables.matcher.find()">
 			<!--- Gather the current match. --->
			<cfset arrayAppend(local.matches,variables.matcher.group()) />
 		</cfloop>
 
		<!--- Return the collected matches. --->
		<cfreturn local.matches />
	</cffunction>
 
 
	<cffunction name="matchGroups" access="public" returntype="array" output="false" hint="I return the collection of all pattern matches found within the given input, broken down by group. NOTE: This resets the internal matcher.">
 		<!--- Define the local scope. --->
		<cfset var local = {} />
 
		<!--- Reset the pattern matcher. --->
		<cfset this.reset() />
 
		<!--- Create an array in which to hold the aggregated pattern matches. --->
		<cfset local.matches = [] />
 
		<!--- Keep looping, looking for matches. --->
		<cfloop condition="variables.matcher.find()"> 
			<!--- Create a match object. --->
			<cfset local.match = {} />
 			<!--- Move all of the captured groups into the match object (with zero being the entire match).--->
			<cfloop index="local.groupIndex" from="0" to="#variables.matcher.groupCount()#" step="1">
 				<!--- Get the local value. --->
				<cfset local.groupValue = variables.matcher.group(javaCast( "int", local.groupIndex )) />
 				<!--- Check to see if the value exists and only set it if it does; ColdFusion seems to not like having a NULL set into the struct (although it really shouldn't have a problem with it). --->
				<cfif structKeyExists( local, "groupvalue" )>
 					<!--- Store the captured value. --->
					<cfset local.match[ local.groupIndex ] = local.groupValue />
				</cfif>
 			</cfloop>
 			<!--- Add the current match object. --->
			<cfset arrayAppend(local.matches,local.match) />
 		</cfloop>
 
		<!--- Return the collected matches. --->
		<cfreturn local.matches />
	</cffunction>
 
 
	<cffunction name="replaceAll" access="public" returntype="string" output="false" hint="I replace all the pattern matches of the original input with the given value.">
 		<!--- Define arguments. --->
		<cfargument name="replacement" type="string" required="true" hint="I am the string with which we are replacing the pattern matches." />
 		<cfargument name="quoteReplacement" type="boolean" required="false" default="false" hint="I determine whether or not the replacement value should be quoted (this will escape any back reference values)."/>
 
		<!--- Check to see if we are quoting the replacement. --->
		<cfif arguments.quoteReplacement>
 			<!--- Quote the replacement string. --->
			<cfreturn variables.matcher.replaceAll(variables.matcher.quoteReplacement(javaCast( "string", arguments.replacement ))) />
 		<cfelse>
 			<!--- Use the replacement text as-is. --->
			<cfreturn variables.matcher.replaceAll(javaCast( "string", arguments.replacement )) />
 		</cfif>
	</cffunction>
 
 
	<cffunction name="replaceFirst" access="public" returntype="string" output="false" hint="I replace the first pattern matche of the original input with the given value.">
 		<!--- Define arguments. --->
		<cfargument name="replacement" type="string" required="true" hint="I am the string with which we are replacing the first pattern match."/>
 		<cfargument name="quoteReplacement" type="boolean" required="false" default="false" hint="I determine whether or not the replacement value should be quoted (this will escape any back reference values)."/>
 
		<!--- Check to see if we are quoting the replacement. --->
		<cfif arguments.quoteReplacement>
 			<!--- Quote the replacement string. --->
			<cfreturn variables.matcher.replaceFirst(variables.matcher.quoteReplacement(javaCast( "string", arguments.replacement ))) />
 		<cfelse>
 			<!--- Use the replacement text as-is. --->
			<cfreturn variables.matcher.replaceFirst(javaCast( "string", arguments.replacement )) />
 		</cfif>
	</cffunction>
 
 
	<cffunction name="replaceWith" access="public" returntype="any" output="false" hint="I replace the current match with the given value. NOTE: Back references within the replacement string will be honored unless the replacement value is quoted (see second arguemnt).">
		<!--- Define arguments. --->
		<cfargument name="replacement" type="string" required="true" hint="I am the value with which we are replacing the previous match." />
 		<cfargument name="quoteReplacement" type="boolean" required="false" default="false" hint="I determine whether or not the replacement value should be quoted (this will escape any back reference values)." />
 
 		<!--- Check to see if we are quoting the replacement. --->
		<cfif arguments.quoteReplacement>
 			<!--- Quote the replacement value before you use it. --->
			<cfset variables.matcher.appendReplacement(variables.buffer,variables.matcher.quoteReplacement(javaCast( "string", arguments.replacement ))) />
 		<cfelse>
 			<!--- Use raw replacement value. --->
			<cfset variables.matcher.appendReplacement(variables.buffer,javaCast( "string", arguments.replacement )) />
 		</cfif>
 
		<!--- Return this object reference for method chaining. --->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction name="reset" access="public" returntype="any" output="false" hint="I reset the pattern matcher.">
 		<!--- Define arguments. --->
		<cfargument name="input" type="string" required="false" hint="I am the optional input with which to reset the pattern matcher."/>
 
		<!--- Check to see if a new input is being used. --->
		<cfif structKeyExists( arguments, "input" )> 
			<!--- Use a new input to reset the matcher. --->
			<cfset variables.matcher.reset(javaCast( "string", arguments.input)) />
 
			<!--- Store the input property. --->
			<cfset variables.input = arguments.input /> 
		<cfelse>
 			<!--- Reset the internal matcher. --->
			<cfset variables.matcher.reset() />
 		</cfif>
 
		<!--- Reset the internal results buffer. --->
		<cfset variables.buffer = createObject( "java", "java.lang.StringBuffer" ).init() />
 
		<!--- Return this object reference for method chaining. --->
		<cfreturn this />
	</cffunction>
 
 
	<cffunction name="result" access="public" returntype="string" output="false" hint="I return the result of the replacement up until this point.">
 		<!--- Since we are no longer dealing with replacements, append the rest of the unmatched input string to the results buffer. --->
		<cfset variables.matcher.appendTail(variables.bufferc) />
 
		<!--- Return the resultand string. --->
		<cfreturn variables.buffer.toString() />
	</cffunction>
 
 
	<!--- ------------------------------------------------- --->
	<!--- ------------------------------------------------- --->
 
 
	<!--- Swap some of the method names; we couldn't name it "find" to begin with otherwise we'd get a ColdFusion error for conflicting with a native function name. --->
	<cfset this.find = this.find_ />
 
</cfcomponent>