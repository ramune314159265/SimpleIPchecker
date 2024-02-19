$IP_FILE_PATH = Join-Path $env:TEMP '/globalip.txt'

$presentGlobalIP = (Invoke-WebRequest https://ipinfo.io/ip).content

if(!(Test-Path $IP_FILE_PATH)){
	New-Item $IP_FILE_PATH -type file
	Set-Content -Path $IP_FILE_PATH -Value $presentGlobalIP

	exit
}

$previousGlobalIP = (Get-Content $IP_FILE_PATH -Encoding UTF8)

if(!($presentGlobalIP -eq $previousGlobalIP)){
	Write-Output a

	Set-Content -Path $IP_FILE_PATH -Value $presentGlobalIP
}
