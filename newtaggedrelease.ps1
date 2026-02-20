param (
 [string]$Name,
 [string]$Version,
 [string]$FileName,
 [string]$PreRelease = 'false',
 [string]$Verbose = "None"
)
try
{
 $ErrorActionPreference = 'Stop';
 $Error.Clear();

 $repository = $env:GITHUB_REPOSITORY
 $runnerPath = $env:GITHUB_WORKSPACE
 $repoName = $repository.Split('/')[1]
 $sourcePath = Join-Path -Path $runnerPath -ChildPath $repoName
 $token = $env:GITHUB_TOKEN
 $verbose = $Verbose

 $baseUri = 'https://api.github.com/repos'
 $apiUrl = "$($baseUri)/$($repository)/releases"

 if ([string]::IsNullOrEmpty($Name))
 {
  $Name = $Version
 }

 [bool]$PreRelease = [System.Convert]::ToBoolean($PreRelease)

 if ($verbose.ToLower() -eq 'verbose')
 {
  Write-Host "NewTaggedRelease DEBUG"
  Write-Host "FileName     : $($FileName)"
  Write-Host "Name         : $($Name)"
  Write-Host "Version      : $($Version)"
  Write-Host "Repository   : $($repository)"
  Write-Host "RunnerPath   : $($runnerPath)"
  Write-Host "RepoName     : $($repoName)"
  Write-Host "SourcePath   : $($sourcePath)"
  Write-Host "ApiUrl       : $($apiUrl)"
  Write-Host "PreRelease   : $($PreRelease)"
 }

 $headers = @{
  Authorization  = "token $($token)"
  'Content-Type' = 'application/json'
 }

 # Resolve release notes path (supports relative or absolute)
 if ([System.IO.Path]::IsPathRooted($FileName)) {
   $ReleaseNotesPath = $FileName
 } else {
   $ReleaseNotesPath = Join-Path -Path $env:GITHUB_WORKSPACE -ChildPath $FileName
 }

 if (Test-Path -Path $ReleaseNotesPath)
 {
  $Body = Get-Content -Path $ReleaseNotesPath -Raw
  $jsonPayload = @{
   tag_name               = $Version
   name                   = $Name
   generate_release_notes = $false
   prerelease             = $PreRelease
   body                   = $Body
  }
 }
 else
 {
  $jsonPayload = @{
   tag_name               = $Version
   name                   = $Name
   generate_release_notes = $true
   prerelease             = $PreRelease
  }
 }

 if ($verbose.ToLower() -eq 'verbose')
 {
  $jsonPayload | ConvertTo-Json -Depth 10 | Write-Host
 }

 Invoke-RestMethod -Uri $apiUrl -Method Post -Body ($jsonPayload | ConvertTo-Json -Depth 10) -Headers $headers
}
catch
{
 $_.InvocationInfo | Out-String
 throw $_.Exception.Message
}
