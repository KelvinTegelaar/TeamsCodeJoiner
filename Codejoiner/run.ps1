using namespace System.Net
param($Request, $TriggerMetadata)


Write-Host "PowerShell HTTP trigger function processed a request."
if ($Request.method -eq "POST") {
    $TeamsID = [System.Web.HttpUtility]::ParseQueryString($Request.Body)
    $URL = Get-Content $TeamsID['ID'] -ErrorAction SilentlyContinue
    if ($URL) {
        $body = @"
    <meta http-equiv="Refresh" content="0; url='$($URL)'" />
"@
    }
    else {
        $body = "This ID is invalid."
    }

}
else {
    $body = @"
    <!DOCTYPE html>
    <html>
    <style>
    input#ID, select {
      width: 30%;
      padding: 12px 20px;
      margin: 8px 0;
      display: inline-block;
      border: 1px solid #ccc;
      border-radius: 4px;
      box-sizing: border-box;
    }
    
    
    .button {
      width: 60%;
      background-color: #6264A7;
      color: white;
      padding: 14px 20px;
      margin: 8px 0;
      border: none;
      cursor: pointer;
    }
    
    .button:hover {
      background-color: #6264A7;
      width: 60%
    }
    .divider{
      width:5px;
      height:auto;
    }
    div {
      border-radius: 5px;
      background-color: #f2f2f2;
      padding: 5px;
      width: 20%
    }
    </style>
    <body>
    <center>
    <title>Quick Teams Join</Title>


    <div>
    <h3>Enter your meeting code.</h3>
    <img src="data:image/png;base64,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">
      <form action="/" method=POST>
        <input type="text" id="ID" name="ID"><br>
        <input class="button" name="Submit" type="submit" value="Join Meeting">
      </form>
    </div>
      </center>
    </body>
    </html>
"@
    
}

Push-OutputBinding -Name Response -Value ([HttpResponseContext]@{
        StatusCode  = [HttpStatusCode]::OK
        Body        = $Body
        ContentType = 'text/html'
    })
