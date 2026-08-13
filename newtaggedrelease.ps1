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

 if ([string]::IsNullOrWhiteSpace($token)) {
  throw "The GITHUB_TOKEN environment variable is empty. Set the 'github_token' input and ensure the workflow has permissions to write repository contents (for example: permissions: { contents: write })."
 }

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

 try
 {
  Invoke-RestMethod -Uri $apiUrl -Method Post -Body ($jsonPayload | ConvertTo-Json -Depth 10) -Headers $headers
 }
 catch
 {
  $responseBody = ''
  $statusCode = 0

  if ($_.Exception.Response) {
   $statusCode = [int]$_.Exception.Response.StatusCode
   try
   {
    $responseStream = $_.Exception.Response.GetResponseStream()
    if ($null -ne $responseStream)
    {
     $reader = [System.IO.StreamReader]::new($responseStream)
     $responseBody = $reader.ReadToEnd()
     $reader.Dispose()
    }
   }
   catch
   {
    }
  }

  if ($statusCode -in @(401, 403))
  {
   throw "GitHub rejected the token while creating the release. Ensure the workflow/job has 'permissions: contents: write' or provide a token with repository write access. API status: $statusCode. Response: $responseBody"
  }

  if (-not [string]::IsNullOrWhiteSpace($responseBody))
  {
   throw "GitHub rejected the release creation request. Response: $responseBody"
  }

  throw $_.Exception.Message
 }
}
catch
{
 $_.InvocationInfo | Out-String
 throw $_.Exception.Message
}
