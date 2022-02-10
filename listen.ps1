function Test-KeyPress
{
    param
    (
        # submit the key you want to detect
        [Parameter(Mandatory)]
        [ConsoleKey]
        $Key,

        [System.ConsoleModifiers]
        $ModifierKey = 0
    )

    # reading keys is a blocking function. To "unblock" it,
    # let's first check if a key press is available at all:
    if ([Console]::KeyAvailable)
    {
        # since a key was pressed, ReadKey() now is NOT blocking
        # anymore because there is already a pressed key waiting
        # to be picked up
        # submit $true as an argument to consume the key. Else,
        # the pressed key would be echoed in the console window
        # note that ReadKey() returns a ConsoleKeyInfo object
        # the pressed key can be found in its property "Key":
        $pressedKey = [Console]::ReadKey($true)

        # if the pressed key is the key we are after...
        $isPressedKey = $key -eq $pressedKey.Key
        if ($isPressedKey)
        {
            # if you want an EXACT match of modifier keys,
            # check for equality (-eq)
            $pressedKey.Modifiers -eq $ModifierKey
            # if you want to ensure that AT LEAST the specified
            # modifier keys were pressed, but you don't care
            # whether other modifier keys are also pressed, use
            # "binary and" (-band). If all bits are set, the result
            # is equal to the tested bit mask:
            # ($pressedKey.Modifiers -band $ModifierKey) -eq $ModifierKey
        }
        else
        {
            # else emit a short beep to let the user know that
            # a key was pressed that was not expected
            # Beep() takes the frequency in Hz and the beep
            # duration in milliseconds:
            [Console]::Beep(1800, 200)

            # return $false
            $false
        }
    }
}

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

    

    if ($eventType -eq 2)
    {
        $driveLetter = $newEvent.SourceEventArgs.NewEvent.DriveName
        $driveLabel = ([wmi]"Win32_LogicalDisk='$driveLetter'").VolumeName
        write-host (get-date -format s) " Drive name = " $driveLetter
        write-host (get-date -format s) " Drive label = " $driveLabel
        # Execute process if drive matches specified condition(s)
        if ($driveLetter -eq 'Z:' -and $driveLabel -eq 'Mirror')
        {
            write-host (get-date -format s) " Starting task in 3 seconds..."
            start-sleep -seconds 3
            # start-process "Z:\sync.bat"
        }
    }
    Remove-Event -SourceIdentifier volumeChange
} while (1-eq1) #Loop until next event
Unregister-Event -SourceIdentifier volumeChange