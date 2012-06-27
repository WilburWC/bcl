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
	  .subnav-fixed {
position: fixed;
top: 40px;
left: 0;
right: 0;
z-index: 1020;
border-color: 
#D5D5D5;
border-width: 0 0 1px;
-webkit-border-radius: 0;
-moz-border-radius: 0;
border-radius: 0;
-webkit-box-shadow: inset 0 1px 0 
white, 0 1px 5px 
rgba(0, 0, 0, .1);
-moz-box-shadow: inset 0 1px 0 #fff, 0 1px 5px rgba(0,0,0,.1);
box-shadow: inset 0 1px 0 
white, 0 1px 5px 
rgba(0, 0, 0, .1);
filter: progid:DXImageTransform.Microsoft.gradient(enabled=false);
}
.subnav {
width: 100%;
height: 36px;
background-color: 
#EEE;
background-repeat: repeat-x;
background-image: -moz-linear-gradient(top, 
whiteSmoke 0%, 
#EEE 100%);
background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%,
whiteSmoke), color-stop(100%,
#EEE));
background-image: -webkit-linear-gradient(top, 
whiteSmoke 0%,
#EEE 100%);
background-image: -ms-linear-gradient(top, 
whiteSmoke 0%,
#EEE 100%);
background-image: -o-linear-gradient(top, 
whiteSmoke 0%,
#EEE 100%);
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#f5f5f5', endColorstr='#eeeeee',GradientType=0 );
background-image: linear-gradient(top, 
whiteSmoke 0%,
#EEE 100%);
border: 1px solid 
#E5E5E5;
-webkit-border-radius: 4px;
-moz-border-radius: 4px;
border-radius: 4px;
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
          <a class="brand" href="#">BetterCraigslist.org</a>
          
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
              <li class="active"><a href="#"><i class="icon-home icon-white"></i>&nbsp;Home</a></li>
              <!---<li><a href="#about">About</a></li>
              <li><a href="#contact">Contact</a></li>--->
			  <li><a href="#" onclick="$('#modalSearch').modal('toggle');"><i class="icon-search icon-white"></i>&nbsp;Search</a></li>
			  <li><a href="#" onclick="$('#modalCities').modal('toggle');" id="curSiteURL" title="Click to change city"></a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div>
      </div>
    </div>
	<div class="row" id="subNavArea">
		<div class="subnav subnav-fixed">
	      <ul class="nav nav-pills">
	        <li class="active"><a href="#javascript">Subnav A</a></li>
	        <li class=""><a href="#modals">Subnav B</a></li>
	      </ul>
	    </div>
	</div>--->
	<div class="row">&nbsp;</div>
    <div class="container-fluid">
      <div class="row-fluid">
        <div class="span4" id="searchResults" style="min-height: 500px; overflow: auto;"></div><!--/span-->
        <div class="span8" id="listingDetails" style="min-height: 500px; overflow: auto;"></div><!--/span-->
      </div><!--/row-->

      <hr>

      <footer>
        <p>&copy; BetterCraigslist.org 2012</p>
      </footer>

    </div><!--/.fluid-container-->
<!--- Modals --->
	<!--- Search Modal --->
	<div class="modal fade hide" id="modalSearch">
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
				<option value="ccc">all community</option>
				<option value="eee">all event</option>
				<option selected="" value="sss">all for sale / wanted</option>
				<option value="" disabled="">--</option>
				<option value="ata"> antiques</option>
				<option value="atd"> antiques - by dealer</option>
				<option value="atq"> antiques - by owner</option>
				<option value="ppa"> appliances</option>
				<option value="ppd"> appliances - by dealer</option>
				<option value="app"> appliances - by owner</option>
				<option value="ard"> arts &amp; crafts - by dealer</option>
				<option value="art"> arts &amp; crafts - by owner</option>
				<option value="ara"> arts+crafts</option>
				<option value="pta"> auto parts</option>
				<option value="ptd"> auto parts - by dealer</option>
				<option value="pts"> auto parts - by owner</option>
				<option value="bad"> baby &amp; kid stuff - by dealer</option>
				<option value="bab"> baby &amp; kid stuff - by owner</option>
				<option value="baa"> baby+kids</option>
				<option value="bar"> barter</option>
				<option value="haa"> beauty+hlth</option>
				<option value="bid"> bicycles - by dealer</option>
				<option value="bik"> bicycles - by owner</option>
				<option value="bia"> bikes</option>
				<option value="boo"> boats</option>
				<option value="bod"> boats - by dealer</option>
				<option value="boa"> boats - by owner</option>
				<option value="bka"> books</option>
				<option value="bkd"> books &amp; magazines - by dealer</option>
				<option value="bks"> books &amp; magazines - by owner</option>
				<option value="bfa"> business</option>
				<option value="bfd"> business/commercial - by dealer</option>
				<option value="bfs"> business/commercial - by owner</option>
				<option value="ctd"> cars &amp; trucks - by dealer</option>
				<option value="cto"> cars &amp; trucks - by owner</option>
				<option value="cta"> cars+trucks</option>
				<option value="emq"> cds / dvds / vhs - by dealer</option>
				<option value="emd"> cds / dvds / vhs - by owner</option>
				<option value="ema"> cds/dvd/vhs</option>
				<option value="moa"> cell phones</option>
				<option value="mod"> cell phones - by dealer</option>
				<option value="mob"> cell phones - by owner</option>
				<option value="cla"> clothes+acc</option>
				<option value="cld"> clothing &amp; accessories - by deal</option>
				<option value="clo"> clothing &amp; accessories - by owne</option>
				<option value="cba"> collectibles</option>
				<option value="cbd"> collectibles - by dealer</option>
				<option value="clt"> collectibles - by owner</option>
				<option value="sya"> computers</option>
				<option value="syd"> computers - by dealer</option>
				<option value="sys"> computers - by owner</option>
				<option value="ela"> electronics</option>
				<option value="eld"> electronics - by dealer</option>
				<option value="ele"> electronics - by owner</option>
				<option value="grq"> farm &amp; garden - by dealer</option>
				<option value="grd"> farm &amp; garden - by owner</option>
				<option value="gra"> farm+garden</option>
				<option value="ssq"> for sale by dealer</option>
				<option value="sso"> for sale by owner</option>
				<option value="zip"> free stuff</option>
				<option value="fua"> furniture</option>
				<option value="fud"> furniture - by dealer</option>
				<option value="fuo"> furniture - by owner</option>
				<option value="gms"> garage sales</option>
				<option value="foa"> general</option>
				<option value="fod"> general for sale - by dealer</option>
				<option value="for"> general for sale - by owner</option>
				<option value="had"> health and beauty - by dealer</option>
				<option value="hab"> health and beauty - by owner</option>
				<option value="hsa"> household</option>
				<option value="hsd"> household items - by dealer</option>
				<option value="hsh"> household items - by owner</option>
				<option value="wan"> items wanted</option>
				<option value="jwa"> jewelry</option>
				<option value="jwd"> jewelry - by dealer</option>
				<option value="jwl"> jewelry - by owner</option>
				<option value="maa"> materials</option>
				<option value="mad"> materials - by dealer</option>
				<option value="mat"> materials - by owner</option>
				<option value="mca"> motorcycles</option>
				<option value="mcd"> motorcycles/scooters - by dealer</option>
				<option value="mcy"> motorcycles/scooters - by owner</option>
				<option value="msa"> music instr</option>
				<option value="msd"> musical instruments - by dealer</option>
				<option value="msg"> musical instruments - by owner</option>
				<option value="pha"> photo+video</option>
				<option value="phd"> photo/video - by dealer</option>
				<option value="pho"> photo/video - by owner</option>
				<option value="rva"> recreational vehicles</option>
				<option value="rvd"> rvs - by dealer</option>
				<option value="rvs"> rvs - by owner</option>
				<option value="sga"> sporting</option>
				<option value="sgd"> sporting goods - by dealer</option>
				<option value="spo"> sporting goods - by owner</option>
				<option value="tia"> tickets</option>
				<option value="tid"> tickets - by dealer</option>
				<option value="tix"> tickets - by owner</option>
				<option value="tla"> tools</option>
				<option value="tld"> tools - by dealer</option>
				<option value="tls"> tools - by owner</option>
				<option value="tad"> toys &amp; games - by dealer</option>
				<option value="tag"> toys &amp; games - by owner</option>
				<option value="taa"> toys+games</option>
				<option value="vga"> video gaming</option>
				<option value="vgd"> video gaming - by dealer</option>
				<option value="vgm"> video gaming - by owner</option>
				<option value="" disabled="">--</option>
				<option value="ggg">all gigs</option>
				<option value="hhh">all housing</option>
				<option value="jjj">all jobs</option>
				<option value="ppp">all personals</option>
				<option value="res">all resume</option>
				<option value="bbb">all services offered</option>
			</select></label>
		</form>
	  </div>
	  <div class="modal-footer">
	    <a href="#" class="btn" data-dismiss="modal">Close</a>
	    <a href="#" onclick="$('#search').submit();" class="btn btn-success">Search</a>
	  </div>
	</div>
	<!--- Cities Model --->
	<div class="modal fade hide" id="modalCities">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal">X</button>
	    <h3>craigslist cities</h3>
	  </div>
	  <div class="modal-body" id="citiesDataArea"></div>
	  <div class="modal-footer">
	    <a href="#" class="btn" data-dismiss="modal">Close</a>
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
	setSiteURL(currentSiteURL);
	//onload functions
		$(document).ready(function() {
		/* START onload */
			//Simple Things
			stretchPanels();
			loadCities();
			//search form
			$('#search').submit(function() 
				{
					console.log('Handler for .submit() called.');
  					//compile the search string to pass to the search system
					//fldareaID,fldsubAreaID,fldquery,fldcatAbb,
					var SendURL		=	'/search/?areaID=' + $('#fldareaID').val() + '&subAreaID=&query=' + $('#fldquery').val() + '&catAbb=' + $('#fldcatAbb').val();
					loadSearchResults(SendURL);
					$('#modalSearch').modal('toggle');
					console.log(SendURL);
					//keep the form from actually submitting
					return false;
				});
			//pop open the search form
			$('#modalSearch').modal('toggle');
			//make sure the display divs are the right height for this browser
			$(window).resize(function(){
	            stretchPanels();
	        	});
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
						$('#searchResults .row a').each(function(index) {
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
						$('#searchResults p.row').each(function(index) {
							$(this).attr('class','item')
						});
						
					}
				});
			}
		function loadDetails(url)
			{
				//listingDetails
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
						$('#listingDetails').html(data);
					}
				});
			}
    	function stretchPanels()
			{
				var myHeight					=	$(window).height() - 140;
				$('#searchResults').css('height',myHeight);
				$('#listingDetails').css('height',myHeight);
				
			}
		function setSiteURL(url)
			{
				currentSiteURL = url;
				$('#modalSearch').modal('toggle');				
				$('#curSiteURL').html('<i class="icon-map-marker icon-white"></i>&nbsp;' + currentSiteURL);
			}
		function loadCities()
			{
				$.ajax({
					url: 'com/scraper.cfc',
					data: {
							method: "getCities"
						},
					crossDomain: false,
					type: 'GET',
					dataType: 'json',
					success: function(data) {
						$('#citiesDataArea').html(data);
						//over ride the click handler on the a tags
						$('#citiesDataArea a').each(function(index) {
							$(this).click(function () {
								setSiteURL($(this).attr('href'));
								$('#modalCities').modal('toggle');
								return false;
							});
						});
					}
				});
			}
		function iwMouseover(i){$("img#iwi").replaceWith('<img id="iwi" src="'+imgList[i]+'" alt="image '+i+'">');return false;}
	</script>
    
  </body>
</html>
