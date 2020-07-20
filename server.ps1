$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://*:80/")
$http.Start()

if ($http.IsListening) {

   write-host "Ready Go!"

   while ($http.IsListening) {
      $context = $http.GetContext()
      if ($context.Request.HttpMethod -eq 'GET') {
         $timeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
         write-host "$($timeStamp)`t$($context.Request.UserHostAddress)`t$($context.Request.Url)" -f 'green'
         $timeStamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }
         [string]$html = "<h1>Hello World</h1><p>$($timeStamp)</>"
         $buffer = [System.Text.Encoding]::UTF8.GetBytes($html) 
         $context.Response.ContentLength64 = $buffer.Length
         $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) 
         $context.Response.OutputStream.Close() 
      }
      elseif ($context.Request.HttpMethod -eq 'PUT') {
         $message = "$($timeStamp)`t$($context.Request.UserHostAddress)`t Stop Request"
         write-host $message -f 'red';
         $buffer = [System.Text.Encoding]::UTF8.GetBytes($message) 
         $context.Response.ContentLength64 = $buffer.Length
         $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) 
         $context.Response.OutputStream.Close()
         $http.Stop()
      }

   }

}

$http.Dispose()
