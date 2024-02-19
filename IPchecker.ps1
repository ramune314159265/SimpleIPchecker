$OutputEncoding = [Text.UTF8Encoding]::UTF8
$IP_FILE_PATH = Join-Path $env:TEMP '/globalip.txt'

$presentGlobalIP = (Invoke-WebRequest https://ipinfo.io/ip).content

if(!(Test-Path $IP_FILE_PATH)){
	New-Item $IP_FILE_PATH -type file
	Set-Content -Path $IP_FILE_PATH -Value $presentGlobalIP

	exit
}

$previousGlobalIP = (Get-Content $IP_FILE_PATH -Encoding UTF8)

if(!($presentGlobalIP -eq $previousGlobalIP)){
	$Toast = [Windows.UI.Notifications.ToastTemplateType, Windows.UI.Notifications, ContentType = WindowsRuntime]::ToastText02
	$ToastContent = [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::GetTemplateContent($Toast)
	$ToastContent.SelectSingleNode('//text[@id="1"]').InnerText = 'グローバルIPアドレスに変更がありました'
	$ToastContent.SelectSingleNode('//text[@id="2"]').InnerText = $presentGlobalIP
	$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
	[Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId).Show($ToastContent)

	Set-Content -Path $IP_FILE_PATH -Value $presentGlobalIP
}
