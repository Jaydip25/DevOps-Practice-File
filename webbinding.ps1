#Add script server of your choice that has ability to execute script on remote server
$scriptserver = "Servername"
$serverlistpath = "\\"+$scriptserver+"\c$\AppD\serverlist.txt"
$remoteserverlist = Get-Content -Path $serverlistpath

foreach ( $remoteserver in $remoteserverlist){
 
# Import the WebAdministration module
Import-Module WebAdministration
# Get all websites
$websites = Get-Website
 
# Iterate through each website and retrieve its URL bindings
foreach ($website in $websites) {
    $siteName = $website.Name
    $bindings = $website.Bindings.Collection
    foreach ($binding in $bindings) {
        $protocol = $binding.Protocol
        $ip = $binding.BindingInformation.Split(":")[0]
        $port = $binding.BindingInformation.Split(":")[1]
        $hostHeader = $binding.HostHeader
        Write-Output "Website '$siteName' is accessible via $protocol://$siteName:$port/$hostHeader"
    }
}
}