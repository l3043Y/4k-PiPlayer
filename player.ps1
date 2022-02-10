Write-Host "Hello world"

function Show-Notification {
    param(
        [String] $Title
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null

    $APP_ID = 'VP.Start Video Looper'

    $template = 
    @"
    <toast>
        <visual>
            <binding template="ToastText02">
                <text id="1">$($Title)</text>
                <text id="2">$(Get-Date -Format 'HH:mm:ss')</text>
            </binding>
        </visual>
    </toast>
"@

    $xml = New-Object Windows.Data.Xml.Dom.XmlDocument
    $xml.LoadXml($template)
    $toast = New-Object Windows.UI.Notifications.ToastNotification $xml
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_ID).Show($toast)

}


$vlc = '"C:\Program Files\VideoLAN\VLC\vlc.exe" '
$video = '"C:\Users\mrbor\Videos\sample\s1.mp4"'
$videoDir = '"C:\Users\mrbor\Videos\sample\"'
$loopOneVideo = '-L -f '
$loopQueue = '--playlist-autostart --loop --playlist-tree '
$loopOneVideoOnQueue = '-R -f --playlist-autostart --no-interact --playlist-tree '

$command = $vlc + $loopOneVideo + $video
$command2 = $vlc + $loopQueue + $videoDir
$command3 = $vlc + $loopOneVideoOnQueue + $videoDir

# Show-Notification -Title "Playing..."
# Invoke-Expression "& $command3"

$driveletter = Get-WmiObject Win32_LogicalDisk | Where-Object{$_.DriveType -eq '2'}
Write-Host $driveletter.DeviceID
# Write-Host $driveletter