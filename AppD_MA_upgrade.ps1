#Add script server of your choice that has ability to execute script on remote servers
$scriptserver = "BRUNYDEVAPP02.devbruin.com" 
$serverlistpath = "\\"+$scriptserver+"\c$\Serverlist\serverlist.txt"
$remoteserverlist = Get-Content -Path $serverlistpath
Enable-WSManCredSSP –Role Server -Force

Foreach ($remoteserver in $remoteserverlist){
    #connecting to target server
    Write-Host 'Remote PS Session established to server' $remoteserver -ForegroundColor Green

    # Define the name of the service you want to check
     $MAService = 'Appdynamics Machine Agent'

# Get the Appdynamics Machine service
try {
    $service = Get-Service -Name $MAService -ErrorAction Stop

    # Check if the service is running
    if ($service.Status -eq 'Running') {
        Write-Host "$MAService Service is running on" $remoteserver -ForegroundColor Green
    } else {
        Write-Host "$MAService Service is not running on" $remoteserver -ForegroundColor Red

        Break
    }
} catch {
    Write-Host " $serviceName Service is not present on the machine or an error occurred: $_" -ForegroundColor Red
    Break
}


    #stop AppDynamics Service
    Get-Service -ComputerName $remoteserver -Name "Appdynamics Machine Agent" | Stop-Service -PassThru

    # Define the path to the folder you want to remove
     $AppDynamicsMApath ="\\"+$remoteserver+"\c$\AppDynamics\MA\*"

   # Check if the folder exists
    if (Test-Path $AppDynamicsMApath) {
    try {
        # Remove the folder and its contents recursively
        Remove-Item -Path $AppDynamicsMApath -Recurse -Force
        Write-Host "Folder $AppDynamicsMApath contents have been removed successfully." -ForegroundColor Yellow
    } catch {
        Write-Error "An error occurred while trying to remove the folder: $_"
        break
    }
} else {
    Write-Host "The folder $AppDynamicsMApath does not exist so please check AppDynamics MA folder path on" $remoteserver -ForegroundColor Red
    break
}
    
    #copying Machine Agent Installation Folder files to Remote server
    
    $DestPath =  "\\"+$remoteserver+"\c$\AppDynamics\MA\"
    $MApath = "\\"+$scriptserver+"\c$\AppD\Machine\MA\*"
    Copy-Item -Recurse -Path $MAPath -destination $DestPath 
    #Checking Machine Agent Folder updated on Remote server or not
    $MA_Folder = "\\"+$remoteserver+"\c$\AppDynamics\MA\conf"
    If (Test-Path $MA_Folder){
    Write-Host ' Machine Agent Installation Folder updated on server '$remoteserver -ForegroundColor Yellow
    }Else{
    Write-host ' Machine Agent Installation Folder not updated on server '$remoteserver -ForegroundColor Red
    break
    }

    #Installaling MA on Remote Server
    $LocalPath = "C:\AppDynamics\MA\InstallService.vbs"
    Invoke-Command -ScriptBlock {cscript.exe $Using:LocalPath} -Computer $remoteserver
	Get-Service -ComputerName $remoteserver -Name "Appdynamics Machine Agent" | Start-Service -PassThru

    }
