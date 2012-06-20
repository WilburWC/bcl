<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>Better Craigslist, cause Craigslist has gotten old and shit</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="css/bootstrap.css" rel="stylesheet">
    <style type="text/css">
      body {
        padding-top: 60px;
        padding-bottom: 40px;
      }
      .sidebar-nav {
        padding: 9px 0;
      }
	  
	  .hoverDark {
	  	background-color: #BABABA;
	  }
    </style>

    <!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le fav and touch icons -->
  </head>

  <body>

    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </a>
          <a class="brand" href="#">Better Craigslist.org</a>
          
		  <!---<div class="btn-group pull-right">
            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
              <i class="icon-user"></i> Username
              <span class="caret"></span>
            </a>
            <ul class="dropdown-menu">
              <li><a href="#">Profile</a></li>
              <li class="divider"></li>
              <li><a href="#">Sign Out</a></li>
            </ul>
          </div>--->
          <div class="nav-collapse">
            <ul class="nav">
              <li class="active"><a href="#">Home</a></li>
              <li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>
			  <li><a href="#" onclick="$('#myModal').modal('toggle');">Search</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>

    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span4" id="searchResults" style="min-height: 500px; max-height: 500px; overflow: auto;"></div><!--/span-->
        <div class="span8" id="listingDetails" style="min-height: 500px; max-height: 500px; overflow: auto;"></div><!--/span-->
      </div><!--/row-->

      <hr>

      <footer>
        <p>&copy; BetterCraigslist.org 2012</p>
      </footer>

    </div><!--/.fluid-container-->

	<div class="modal fade hide" id="myModal">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal">X</button>
	    <h3>search craigslist</h3>
	  </div>
	  <div class="modal-body">
	    <form id="search" action="/search/" method="GET" class="well form-horizontal">
			<input type="hidden" name="areaID" id="fldareaID" value="18">
			<input type="hidden" name="subAreaID" id="fldsubAreaID" value="">
			<label for="query">Search For: <input id="fldquery" name="query" class="span3" placeholder="Type something..."></label>	
			<label for="catAbb">Category: 
			<select name="catAbb" id="fldcatAbb" class="span3">
				<option value="ccc">community
				<option value="eee">events
				<option value="ggg">gigs
				<option value="hhh">housing
				<option value="jjj">jobs
				<option value="ppp">personals
				<option value="res">resumes
				<option value="sss" selected="selected">for sale
				<option value="bbb">services
			</select></label>
		</form>
	  </div>
	  <div class="modal-footer">
	    <a href="#" class="btn" data-dismiss="modal">Close</a>
	    <a href="#" onclick="$('#search').submit();" class="btn btn-success">Search</a>
	  </div>
	</div>

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
	<script src="js/bootstrap.min.js"></script>
	<script src="js/bootstrap-modal.js"></script>
	
    <script type="text/javascript">
    //global vars 
	var currentSiteURL = "http://phoenix.craigslist.org";
	//onload functions
		$(document).ready(function() {
		/* START onload */
			//search form
			$('#search').submit(function() 
				{
					console.log('Handler for .submit() called.');
  					//compile the search string to pass to the search system
					//fldareaID,fldsubAreaID,fldquery,fldcatAbb,
					var SendURL		=	'/search/?areaID=' + $('#fldareaID').val() + '&subAreaID=&query=' + $('#fldquery').val() + '&catAbb=' + $('#fldcatAbb').val();
					loadSearchResults(SendURL);
					$('#myModal').modal('toggle');
					console.log(SendURL);
					//keep the form from actually submitting
					return false;
				});
			//pop open the search form
			$('#myModal').modal('toggle');
		/* END onload */
		});
	
	//on demand functions	
		function loadSearchResults(myURL)
			{
				//clean the data
				myURL		=	myURL.replace(currentSiteURL,'');
				$.ajax({
					url: 'com/scraper.cfc',
					data: {
							method: "getListings",
							url: currentSiteURL + myURL
						},
					type: 'GET',
					dataType: 'json',
					success: function(data) {
						//populate the search results with the return data
						$('#searchResults').html(data);
						//clear the details area
						$('#listingDetails').html('');
						//override the native click function of the a tag in the search results
						$('.ban a').each(function(index) {
							$(this).click(function () {
								loadSearchResults($(this).attr('href'));
								return false;
							});
						});
						
						//attach a hover effect to the row
						$(".row").hover(function()
							{
								$(this).toggleClass("hoverDark");
							});

						//override the native click function of the a tag in the pagination results
						$('.row a:even').each(function(index) {
							if(index==0)
								{
									loadDetails($(this).attr('href'));
								}
							$(this).click(function () {
								loadDetails($(this).attr('href'));
								return false;
							});
						});
						
						//change out the row class with an innocuous one not affected by bootstrap
						$('p.row').each(function(index) {
							$(this).attr('class','item')
						});
						
					}
				});
			}
		function loadDetails(url)
			{
				//listingDetails
				console.log('You clicked on: ' + url);
				$.ajax({
					url: 'com/scraper.cfc',
					data: {
							method: "getDetails",
							url: url
						},
					crossDomain: false,
					type: 'GET',
					dataType: 'json',
					success: function(data) {
						console.log(url);
						$('#listingDetails').html(data);
					}
				});
			}
    </script>
    
  </body>
</html>
