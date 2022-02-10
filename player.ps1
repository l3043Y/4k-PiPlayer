$APP_NAME = "VP.Start Video Looper"
Write-Host "--------------$APP_NAME--------------"
$vlc = '"C:\Program Files\VideoLAN\VLC\vlc.exe" '
$video_dir = "\VP.Start_Demo\"
# $video_dir = "\VP.Start_Demo\"

$loopOneVideo = '-L -f '
$loopQueue = '--playlist-autostart --loop --playlist-tree '
$loopOneVideoOnQueue = '-R -f --playlist-autostart --no-interact --playlist-tree '

$command = $vlc + $loopOneVideo + $video
$command2 = $vlc + $loopQueue + $videoDir
$command3 = $vlc + $loopOneVideoOnQueue + $videoDir
$terminateVLC = 'TASKKILL /IM VLC.EXE'
function Play-From-Drive{
    param(
        [String] $Drive_Letter
    )
    $path = $Drive_Letter + $video_dir
    write-host $path
    if (!(test-path $path)) {
        mkdir $path
        Show-Notification -Title "Directory Created!"
        # $note = $path + "PLACE_VIDEO_FILES_HERE"
        # New-Item $note
        # Set-Content $note 'VP.Start Video Looper'
    } else {
        Show-Notification -Title "Playing in 3 from " + $path
        write-host (get-date -format s) " Starting task in 3 seconds..."
        start-sleep -seconds 3
        $PLAY = $vlc + $loopOneVideoOnQueue + $path
        Invoke-Expression "& $PLAY"
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

    $plugged_drive = Get-CimInstance -ClassName Win32_LogicalDisk | Where-Object{$_.DriveType -eq '2'}
    $drive_l = $plugged_drive.DeviceID
    # Write-Host $drive_l
    if($drive_l) {
        Play-From-Drive -Drive_Letter $drive_l
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
            Show-Notification -Title "Killing VLC..."
            Invoke-Expression "& $terminateVLC"
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
    Unregister-Event -SourceIdentifier volumeChange
    Get-EventSubscriber
}