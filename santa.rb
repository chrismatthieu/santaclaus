require "rubygems"
require "sinatra"
require "rest_client"

get "/" do
  html = '<html><head><link type="text/css" rel="stylesheet" href="/style.css" media="screen" /></head>'
  html <<  '<body>'
  html << '<form id="call" method="post" action="/"> 
  				<div id="input-wrap"> <center><h1>Santa Calling</h1></center><br/>
					<em>(</em> 
  					<fieldset> 
  						<input type="text" id="areacode" name="areacode" class="text" maxlength="3" tabindex="1" /> 
  					</fieldset> 
  					<em>)</em> 
  					<fieldset> 
  						<input type="text" id="firstthree" name="num1" class="text" maxlength="3" tabindex="2" /> 
  					</fieldset> 
  					<em>-</em> 
  					<fieldset> 
              <input type="text" id="lastfour" name="num2" class="text" maxlength="4" tabindex="3" /> 
  					</fieldset> 
  					<fieldset> 
              <input type="text" id="recipient" name="recipient" class="text" value="Recipient\'s Name" tabindex="4" /> 
  					</fieldset> 
  				</div>
  				<fieldset> 
  					<input type="submit" value="Call" id="submit" tabindex="5" /> 
  				</fieldset> 
  			</form>
  			
  			<div id="tropo-donate" class="clearfix"> 
        		<div id="tropo"> 
        			<p>Voice API provided by <a href="http://tropo.com/">Tropo</a></p> 
        			<a href="http://tropo.com/"><img src="/tropo-logo.png" id="tropo-logo" alt="Tropo Logo" /></a> 
        	<br/><br/></div>
        </div></body></html>'
  return html
end

post "/" do
  
  RestClient.get 'http://api.tropo.com/1.0/sessions?action=create&token=0a061c943b623546886b62f124d0f329a71beea4135c0e8f0b55bc61e33ffa211ce1301a15a58c37781f5715&number=1' + params[:areacode] + params[:num1] + params[:num2] + '&name=' + params[:recipient]
  
  html = '<html><head><link type="text/css" rel="stylesheet" href="/style.css" media="screen" /></head>'
  html <<  '<body>'
  html << '<div id="call-wrap">Calling...</div>
  			
  			<div id="tropo-donate" class="clearfix"> 
        		<div id="tropo"> 
        			<p>Voice API provided by <a href="http://tropo.com/">Tropo</a></p> 
        			<a href="http://tropo.com/"><img src="/tropo-logo.png" id="tropo-logo" alt="Tropo Logo" /></a> 
        	<br/><br/></div>
        </div></body></html>'
  return html
  
end