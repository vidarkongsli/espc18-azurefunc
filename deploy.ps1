param(
    [Parameter(Mandatory = $false)]
    $projectFile = "\espc18-azurefunc.csproj",
    [Parameter(Mandatory = $false)]
    $deploymentSource = $env:DEPLOYMENT_SOURCE,
    [Parameter(Mandatory = $false)]
    $deploymentTarget = 'd:\home\data\SitePackages',
    [Parameter(Mandatory = $false)]
    $deploymentTemp = $env:DEPLOYMENT_TEMP
)
$ErrorActionPreference = 'stop'
$global:ProgressPreference = 'silentlycontinue'

. $PSScriptRoot\deployment\helpers\source-deploy-helpers.ps1

$projectFilePath = join-path -Path $deploymentSource -ChildPath $projectFile

# 1. Restore
dotnet restore "$projectFilePath"
exitWithMessageOnError "Nuget restore failed"

# 2. Build
dotnet msbuild "$projectFilePath" /t:build /p:deployonbuild=true `
    /p:configuration=release `
    /p:publishurl="$deploymentTemp"

exitWithMessageOnError "Build failed"

# 3. Zip
New-ZipDirIfNotExists $deploymentTarget
$zipArchive = "$(find-githash).zip"
Write-Output "Compressing content from $deploymentTemp\* to $deploymentTarget\$zipArchive"
Compress-Archive -Path "$deploymentTemp\*" -DestinationPath $deploymentTarget\$zipArchive -force
$zipArchive | Out-File "$deploymentTarget\packagename.txt" -Encoding ASCII -NoNewline
exitWithMessageOnError "Application publish failed"
