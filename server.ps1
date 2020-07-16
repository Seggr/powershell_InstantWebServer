$http = [System.Net.HttpListener]::new()
$http.Prefixes.Add("http://localhost:8080/")
$http.Start()

if ($http.IsListening) {
   write-host " HTTP Server Ready!  " -f 'black' -b 'gre'
   write-host "now try going to $($http.Prefixes)" -f 'y'
   write-host "then try going to $($http.Prefixes)other/path" -f 'y'
}

while ($http.IsListening) {
   $context = $http.GetContext()
   if ($context.Request.HttpMethod -eq 'GET') {
      write-host "$($context.Request.UserHostAddress)  =>  $($context.Request.Url)" -f 'mag'
      [string]$html = "<h1>Hello World</h1>"
      $buffer = [System.Text.Encoding]::UTF8.GetBytes($html) 
      $context.Response.ContentLength64 = $buffer.Length
      $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) 
      $context.Response.OutputStream.Close() 

   }

}
