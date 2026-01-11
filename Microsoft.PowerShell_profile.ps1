# PowerShell Profile - Matching zsh prompt style
# Copy this to: $HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1

# Vi mode
Set-PSReadLineOption -EditMode Vi

# Git branch function
function Get-GitBranch {
    $branch = git symbolic-ref HEAD 2>$null
    if ($branch) {
        $branch = $branch -replace 'refs/heads/', ''
        if ($branch.Length -gt 30) {
            $branch = $branch.Substring(0, 30) + "..."
        }
        return " ($branch)"
    }
    return ""
}

# Custom prompt matching zsh style
# Green user@host, blue directory, yellow git branch
function prompt {
    $lastExitCode = $LASTEXITCODE
    $ESC = [char]0x1b

    $green = "$ESC[1;32m"
    $blue = "$ESC[1;34m"
    $yellow = "$ESC[1;33m"
    $red = "$ESC[1;31m"
    $reset = "$ESC[0m"

    $user = $env:USERNAME
    $host_name = $env:COMPUTERNAME
    $path = (Get-Location).Path -replace [regex]::Escape($HOME), '~'
    $gitBranch = Get-GitBranch

    $promptChar = '$'
    $promptColor = $reset
    if ($lastExitCode -ne 0 -and $null -ne $lastExitCode) {
        $promptColor = $red
    }

    "$green$user@$host_name $blue$path$yellow$gitBranch$reset $promptColor$promptChar$reset "
}

# Set window title
$Host.UI.RawUI.WindowTitle = "$env:USERNAME@$env:COMPUTERNAME: $(Get-Location)"
