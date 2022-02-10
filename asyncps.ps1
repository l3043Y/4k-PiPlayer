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




# register your event
# Register-ObjectEvent -InputObject $timer -EventName Elapsed -SourceIdentifier Chatty -Action {
#     Write-Host '.' -NoNewline
#     $pressed = Test-KeyPress -Key K -ModifierKey 'Control,Shift'
#     if ($pressed) { 
#         Unregister-Event Chatty
#     }
#     # Start-Sleep -Seconds 3
# }

$Timer = [System.Timers.Timer]::new(500)
Register-ObjectEvent -InputObject $Timer -EventName Elapsed -SourceIdentifier Chatty -Action {
    Write-Host '.' -NoNewline
    $pressed = Test-KeyPress -Key K -ModifierKey 'Control,Shift'
    if ($pressed) { 
        Unregister-Event Chatty
    }
}
$Timer.Start()

# Unregister-Event Chatty
# get-eventsubscriber
