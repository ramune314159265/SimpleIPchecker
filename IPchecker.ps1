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
	$xml = @"
	<toast>
		<visual>
			<binding template="ToastGeneric">
				<text>グローバルIPアドレスに変更がありました</text>
				<text>$presentGlobalIP </text>
			</binding>
		</visual>

		<actions>
			<action content="IPを表示" activationType="protocol" arguments="https://ipinfo.io/ip" />
		</actions>

	</toast>
"@

	$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
	$XmlDocument.loadXml($xml)
	$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
	[Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier($AppId).Show($XmlDocument)

	Set-Content -Path $IP_FILE_PATH -Value $presentGlobalIP
}
