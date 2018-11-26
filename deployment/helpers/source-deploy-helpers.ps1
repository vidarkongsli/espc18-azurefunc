function exitWithMessageOnError($1) {
    if ($? -eq $false) {
        Write-Output "An error has occurred during web site deployment."
        Write-Output $1
        exit 1
    }
}

function isCurrentScriptDirectoryGitRepository {
    $here = $PSScriptRoot
    if ((Test-Path "$here\.git") -eq $TRUE) {
        return $TRUE
    }
  
    # Test within parent dirs
    $checkIn = (Get-Item $here).parent
    while ($NULL -ne $checkIn) {
        $pathToTest = $checkIn.fullname + '/.git'
        if ((Test-Path $pathToTest) -eq $TRUE) {
            return $TRUE
        }
        else {
            $checkIn = $checkIn.parent
        }
    }
    $FALSE
}

function find-githash {
    $isInGit = isCurrentScriptDirectoryGitRepository
    if (-not($isInGit)) {
        get-date -Format 'yyyy-MM-dd_hh-mm-ss'
    }
    else {
        (git rev-parse HEAD).Substring(0,9)
    }
}

function New-ZipDirIfNotExists($zipdir) {
    if (-not(test-path $zipdir -PathType Container)) {
        mkdir $zipdir | out-null  
    }
}
