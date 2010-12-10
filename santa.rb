require "rubygems"
require "sinatra"
require "rest_client"
require "uri"

get "/" do
  html = '<html><head><script src="http://code.jquery.com/jquery.js"></script>
          <link type="text/css" rel="stylesheet" href="/style.css" media="screen" />
          <script type="text/javascript" src="jquery.autotab-1.1b.js"></script>
          <script language="javascript">'
  html << "$(document).ready(function() {

          		var clearMePrevious = '';

          		// clear input on focus
          		$('.clearMeFocus').focus(function()
          		{
          		if($(this).val()==$(this).attr('title'))
          		{
          		clearMePrevious = $(this).val();
          		$(this).val('');
          		}
          		});

          		// if field is empty afterward, add text again
          		$('.clearMeFocus').blur(function()
          		{
          		if($(this).val()=='')
          		{
          		$(this).val(clearMePrevious);
          		}
          		});
              $('#areacode, #num1, #num2').autotab_magic().autotab_filter('numeric');

              });
          </script>
          <script type=\"text/javascript\">

            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-2483685-17']);
            _gaq.push(['_trackPageview']);

            (function() {
              var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
              ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
              var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();

          </script>
          </head>"
  html << '<body><div id="getdata"><form> 
  				<table width="400" border="0"><tr><td><div id="input-wrap">
  				<center><h1>SantaCall.Us</h1><br/>
  				Enter the phone number and name of the person that you would like for Santa to call. If you enter your email address, he\'ll send you their Christmas wish!<br/><br/>
					<em>(</em> 
  					<fieldset> 
  						<input type="text" id="areacode" name="areacode" class="text" maxlength="3" tabindex="1" /> 
  					</fieldset> 
  					<em>)</em> 
  					<fieldset> 
  						<input type="text" id="num1" name="num1" class="text" maxlength="3" tabindex="2" /> 
  					</fieldset> 
  					<em>-</em> 
  					<fieldset> 
              <input type="text" id="num2" name="num2" class="text" maxlength="4" tabindex="3" /> 
  					</fieldset> 
  					<fieldset> 
              <input type="text" id="recipient" name="recipient" value="Recipient\'s Name" tabindex="4" class="clearMeFocus" title="Recipient\'s Name"/> 
  					</fieldset> 
  					<fieldset> 
              <input type="text" id="emailto" name="emailto" value="Your email address" tabindex="5" class="clearMeFocus" title="Your email address"/> 
  					</fieldset> 

  				</div>
  				<fieldset> 
  					<input type="button" value="Call" id="submit" tabindex="5" /> 
  				</fieldset> 
  				</center></td></tr></table>
  			</form>
  			<script>
          $("#submit").click(function() {
          $("#getdata").hide();
          $("#calling").show();
          
          $.ajax({ url: \'/\', data: { \'areacode\': $(\'#areacode\').val(), \'num1\': $(\'#num1\').val(), \'num2\': $(\'#num2\').val(), \'recipient\': $(\'#recipient\').val(), \'emailto\': $(\'#emailto\').val()}, type: \'post\' });
          
          });

        </script>
        
  			</div>
  			<div id="calling" style="display:none"><div id="call-wrap"><h1>Santa is calling now!</h1><br/><p><form><input type="button" id="again" value="again?" /></form></p><br/><br/><br/><br/></div>
  			<script>

          $("#again").click(function() {
            $("#getdata").show();
            $("#calling").hide();          
          });

        </script>
  			
  			</div>
  			
  			<div id="tropo-donate" class="clearfix"> 
        		<div id="tropo"> 
        			<p>Voice API provided by <a href="http://tropo.com/">Tropo</a></p> 
        			<a href="http://tropo.com/"><img src="/tropo-logo.png" id="tropo-logo" alt="Tropo Logo" /></a> 
        	<br/><br/></div>
        </div>
        </body></html>'
  return html
end

post "/" do
    # Place call using Tropo's Scripting API
    
    if params[:recipient] == "Recipient's Name"
      recipient = ""
    else 
      recipient = params[:recipient]
    end
    if params[:emailto] == "Your email address"
      emailto = ""
    else 
      emailto = params[:emailto]
    end
    
    RestClient.get 'http://api.tropo.com/1.0/sessions?action=create&token=0a061c943b623546886b62f124d0f329a71beea4135c0e8f0b55bc61e33ffa211ce1301a15a58c37781f5715&number=1' + params[:areacode] + params[:num1] + params[:num2] + '&name=' + URI.escape(recipient) + '&emailto=' + URI.escape(emailto)
    
end

post "/transcribe" do
  require 'json'
  require 'pony'
  
  TPMI_SMTP_OPTIONS = {
      :address        => "smtp.sendgrid.net",
      :port           => "25",
      :authentication => :plain,
      :user_name      => ENV['SENDGRID_USERNAME'],
      :password       => ENV['SENDGRID_PASSWORD'],
      :domain         => ENV['SENDGRID_DOMAIN'],
  }
  
  transcript_json = JSON.parse(request.body.read)
  identifier = transcript_json['result']['identifier']
  transcript = transcript_json['result']['transcription']
  
  maildata = identifier.split(":")

  Pony.mail(:to => maildata[0],
              :from => "BigGuy@SantaCall.us",
              :subject => "Christmas Wishes!",
              :body => maildata[1].capitalize + " just asked Santa for the following wish: " + transcript,
              :via => :smtp, :via_options => TPMI_SMTP_OPTIONS)
                
end