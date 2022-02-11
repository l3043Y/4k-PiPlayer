$APP_NAME = "VP.Start Video Looper"
Write-Host "--------------$APP_NAME--------------"
$vlc = '"C:\Program Files\VideoLAN\VLC\vlc.exe" '
$idle_video = '"C:\opt\Final Concept 3-4.mp4"'
$no_video = '"C:\opt\Final Concept 3-4.mp4"'

$loopOneVideo = '--no-video-title-show -L -f '

$loopIdleVideo = $vlc + $loopOneVideo + $idle_video
$loopNoVideo = $vlc + $loopOneVideo + $no_video

$terminateVLC = 'TASKKILL /IM VLC.EXE'
$kill_exporerer = 'taskkill /F /IM explorer.exe'

function Play-From-Drive{
    param(
        [String] $Drive_Letter
    )
    Invoke-Expression "& $terminateVLC"
    $root_drive = $Drive_Letter + '\*'
    $full_path_videos = Get-ChildItem $root_drive -Recurse -Include "*.mp4","*.MP4","*.Mp4", "*.hevc" | ForEach-Object { "$_" }
    $JoinedString = '"' + ($full_path_videos -join '" "' ) + '"'
    $loopMultipleFiles = $vlc + $loopOneVideo + $JoinedString
    if($full_path_videos.Length() -gt 0 ) {
        Invoke-Expression "& $loopMultipleFiles"
    } else {
        Invoke-Expression "& $loopNoVideo"
    }
}
function Show-Notification {
    param(
        [String] $Title
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.UI.Notifications.ToastNotification, Windows.UI.Notifications, ContentType = WindowsRuntime] | Out-Null
    [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime] | Out-Null
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
    [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($APP_NAME).Show($toast)
}

try {
    Invoke-Expression "& $kill_exporerer"

    $plugged_drive = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object{$_.DriveType -eq '2'}
    $drive_l = $plugged_drive.DeviceID
    # Write-Host $drive_l
    if($drive_l) {
        Play-From-Drive -Drive_Letter $drive_l
    } else {
        Invoke-Expression "& $loopIdleVideo"
    }
    # Main code
    Register-WmiEvent -Class win32_VolumeChangeEvent -SourceIdentifier volumeChange
    write-host (get-date -format s) " Beginning script..."
    do{
        $newEvent = Wait-Event -SourceIdentifier volumeChange
        $eventType = $newEvent.SourceEventArgs.NewEvent.EventType
        $eventTypeName = switch($eventType)
        {
            1 {"Configuration changed"}
            2 {"Device arrival"}
            3 {"Device removal"}
            4 {"docking"}
        }
        write-host (get-date -format s) " Event detected = " $eventTypeName

        if ($eventType -eq 3) {
            # Show-Notification -Title "Killing VLC..."
            Invoke-Expression "& $terminateVLC"
            Invoke-Expression "& $loopIdleVideo"

        }
        if ($eventType -eq 2)
        {
            $driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
            $driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
            write-host (get-date -format s) " Drive name = " $driveLetter
            write-host (get-date -format s) " Drive label = " $driveLabel

            Play-From-Drive -Drive_Letter $driveLetter
        }
        Remove-Event -SourceIdentifier volumeChange
    } while (1-eq1) #Loop until next event
} finally {
    write-host "Unregistered Volume Change Event"
    Invoke-Expression "& Start explorer.exe"

    Unregister-Event -SourceIdentifier volumeChange
    Get-EventSubscriber
}