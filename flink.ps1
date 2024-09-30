#overall Jobs Running
$flinkjob = "https://flink.k8s.devbruin.com/jobs"
$jobs = Invoke-RestMethod -Uri $flinkjob
$jobcount = $jobs.jobs.Count 
$JobIdArray = $jobs.jobs.id
$stringRunningJobs = "name=Custom Metrics|Flink Metrics|JobID Metrics|Running Jobs,value="
Write-Host  $stringRunningJobs$jobcount",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"

#if else statement to check running jobs
if( $jobcount -eq 0 ){
#Write-Host "No Running Jobs Flink" $jobcount  
}else{
Write-Host
#Write-Host "Total Jobs Running on Flink="$jobcount
Write-Host
Write-Host

foreach ( $JobID in $JobIdArray){

if ( $JobID -eq $null) {

#Write-Host JobID is Null so closing  Program.
break

}else {
Write-Host 
Write-Host
#Write-Host  Please find Metrics count of JobID $JobID
Write-Host 
Write-Host 
$uptime = Invoke-RestMethod -Uri https://flink.k8s.devbruin.com/jobs/$JobID/metrics?get=uptime
$restarts = Invoke-RestMethod -Uri https://flink.k8s.devbruin.com/jobs/$JobID/metrics?get=numRestarts
$totalcheckpoint = Invoke-RestMethod -Uri https://flink.k8s.devbruin.com/jobs/$JobID/metrics?get=totalNumberOfCheckpoints
$failedCheckpoints = Invoke-RestMethod -Uri https://flink.k8s.devbruin.com/jobs/$JobID/metrics?get=numberOfFailedCheckpoints

if ( $uptime.value -eq $null){
$upvalue = 0
#Write-Host  Total uptime count is:  $upvalue
$MUCSFCEC = $upvalue
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Uptime count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}else{
#Write-Host  Total uptime count is: $uptime.value
$MUCSFCEC = $uptime.value
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Uptime count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}
if ($restarts.value -eq $null){
$restart = 0
#Write-Host  Total restarts count is: 0
$MUCSFCEC = $restart
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Restarts count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"

}else{
#Write-Host  Total restarts count is: $restarts.value
$MUCSFCEC = $restarts.value
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Restarts count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}
if ($totalcheckpoint.value -eq $null){
$Totalcheckpoint = 0
#Write-Host  Total checkpoint count is: 0
$MUCSFCEC = $Totalcheckpoint
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Totalcheckpoint count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}else {
#Write-Host  Total checkpoint count is: $totalcheckpoint.value
$MUCSFCEC = $totalcheckpoint.value
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|Totalcheckpoint count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}
if ($failedCheckpoints.value -eq $null){
$FailedCheckpoints = 0
#Write-Host  Total failedCheckpoints count is: 0
$MUCSFCEC = $FailedCheckpoints
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|FailedCheckpoints count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}else {
#Write-Host  Total failedCheckpoints count is: $failedCheckpoints.value

$MUCSFCEC = $failedCheckpoints.value
$stringMUCSFCEC = "name=Custom Metrics|Flink Metrics|JobID Metrics|"+$JobID+"|FailedCheckpoints count,value="
Write-Host  $stringMUCSFCEC$MUCSFCEC",aggregator=OBSERVATION, time-rollup=CURRENT, cluster-rollup=INDIVIDUAL"
}
}
}
}
