# Prompt
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\uew.omp.json" | Invoke-Expression
# oh-my-posh init pwsh --config "D:\Github\winconfig\terminal\oh-my-posh\zen.omp.toml" | Invoke-Expression
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Module
Import-Module -Name Terminal-Icons
Import-Module PSReadLine
# Import-Module -Name Microsoft.WinGet.CommandNotFound
# Import-Module "gsudoModule"

# PSReadLine Configuration
Set-PSReadLineOption -PredictionViewStyle ListView
# Shows navigable menu of all options when hitting Tab
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
# Autocompleteion for Arrow keys
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -ShowToolTips
Set-PSReadLineOption -PredictionSource History
#Set the color for Prediction (auto-suggestion)
Set-PSReadlineOption -Colors @{InlinePrediction = 'DarkGreen' }

# Aliases
# Set-Alias Prompt gsudoPrompt
Set-Alias img2ascii ascii-image-converter
Set-Alias mpv mpvnet

if (Test-CommandExists nvim) {
    $EDITOR='nvim'
} elseif (Test-CommandExists pvim) {
    $EDITOR='pvim'
} elseif (Test-CommandExists vim) {
    $EDITOR='vim'
} elseif (Test-CommandExists vi) {
    $EDITOR='vi'
} elseif (Test-CommandExists code) {
    $EDITOR='code'
} elseif (Test-CommandExists notepad) {
    $EDITOR='notepad'
} elseif (Test-CommandExists notepad++) {
    $EDITOR='notepad++'
} elseif (Test-CommandExists sublime_text) {
    $EDITOR='sublime_text'
}
Set-Alias -Name vim -Value $EDITOR

function ll { Get-ChildItem -Path $pwd -File }
function g { Set-Location $HOME\Documents\Github }
function gcom {
    git add .
    git commit -m "$args"
}
function lazyg {
    git add .
    git commit -m "$args"
    git push
}
function Get-PubIP {
    (Invoke-WebRequest http://ifconfig.me/ip ).Content
}
function uptime {
    # Windows Powershell only
	If ($PSVersionTable.PSVersion.Major -eq 5 ) {
		Get-WmiObject win32_operatingsystem |
        Select-Object @{EXPRESSION={ $_.ConverttoDateTime($_.lastbootuptime)}} | Format-Table -HideTableHeaders
	} Else {
        net statistics workstation | Select-String "since" | foreach-object {$_.ToString().Replace('Statistics since ', '')}
    }
}
function reload-profile {
    & $profile
}
function find-file($name) {
    Get-ChildItem -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | ForEach-Object {
        $place_path = $_.directory
        Write-Output "${place_path}\${_}"
    }
}
function unzip ($file) {
    Write-Output("Extracting", $file, "to", $pwd)
    $fullFile = Get-ChildItem -Path $pwd -Filter .\cove.zip | ForEach-Object { $_.FullName }
    Expand-Archive -Path $fullFile -DestinationPath $pwd
}
function ix ($file) {
    curl.exe -F "f:1=@$file" ix.io
}
function grep($regex, $dir) {
    if ( $dir ) {
        Get-ChildItem $dir | select-string $regex
        return
    }
    $input | select-string $regex
}
function touch($file) {
    "" | Out-File $file -Encoding ASCII
}
function df {
    get-volume
}
function sed($file, $find, $replace) {
    (Get-Content $file).replace("$find", $replace) | Set-Content $file
}
function which($name) {
    Get-Command $name | Select-Object -ExpandProperty Definition
}
function export($name, $value) {
    set-item -force -path "env:$name" -value $value;
}
function pkill($name) {
    Get-Process $name -ErrorAction SilentlyContinue | Stop-Process
}
function pgrep($name) {
    Get-Process $name
}

# Functions
# function Send-Completions {
#     $commandLine = ""
#     $cursorIndex = 0
#     [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$commandLine, [ref]$cursorIndex)
#     $completionPrefix = $commandLine

#     $result = "`e]633;Completions"
#     if ($completionPrefix.Length -gt 0) {
#       $completions = TabExpansion2 -inputScript $completionPrefix -cursorColumn $cursorIndex
#       if ($null -ne $completions.CompletionMatches) {
#         $result += ";$($completions.ReplacementIndex);$($completions.ReplacementLength);$($cursorIndex);"
#         $result += $completions.CompletionMatches | ConvertTo-Json -Compress
#       }
#     }
#     $result += "`a"

#     Write-Host -NoNewLine $result
#   }

#   function Set-MappedKeyHandlers {
#     # Terminal suggest - always on keybindings
#     Set-PSReadLineKeyHandler -Chord 'F12,b' -ScriptBlock {
#       Send-Completions
#     }
#   }

#   # Register key handlers if PSReadLine is available
#   if (Get-Module -Name PSReadLine) {
#     Set-MappedKeyHandlers
#   }
#   else {
#     Write-Host "PsReadline was disabled. Shell Completion was not enabled."
# }

function yy {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

function whereis ($command) {
	Get-Command -Name $command -ErrorAction SilentlyContinue |
	Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

# function Get-ClickableFiles {
#     param([string]$Path = ".")

#     # Get file details
#     Get-ChildItem -Path $Path | ForEach-Object {
#         $filePath = $_.FullName
#         $fileName = $_.Name
#         $mode = $_.Mode
#         $lastWriteTime = $_.LastWriteTime
#         $length = $_.Length

#         # Create clickable link for the file name
#         $clickableName = "$([char]27)]8;;file://$filePath`a$fileName$([char]27)]8;;`a"

#         # Output objects with clickable names
#         [PSCustomObject]@{
#             Mode         = $mode
#             LastWriteTime = $lastWriteTime
#             Length       = $length
#             Name         = $clickableName
#         }
#     } | Format-Table -AutoSize
# }
