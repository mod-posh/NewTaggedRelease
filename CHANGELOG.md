# Changelog

All changes to this project should be reflected in this document.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [[0.0.3.3]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.3.3) - 2026-02-20

Small change to determining filename, in case a fullpathis sent as filename instead of just filename.

---

## [[0.0.3.2]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.3.2) - 2024-07-18

BUGFIX: Still struggling with booleans, rule of thumb just use strings. Handle the conversion in the script so we can use booleans there.

What Changed:

- Changed PreRelease to a string in `action.yml`
- Changed PreRelease to a string in `newtaggedrelease.ps1`
  - Added logic to convert that value to a boolean

---

## [[0.0.3.1]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.3.1) - 2024-07-18

BUGFIX: Quote string parameters and boolean, as well as cast that string to bool.

```powershell
… 0.0.0 -Version 1.0.0.0 -FileName RELEASE.md -PreRelease false -Verbos …

Cannot process argument transformation on parameter 'PreRelease'. Cannot
convert value "System.String" to type "System.Boolean". Boolean
parameters accept only Boolean values and numbers, such as $True,
$False, 1 or 0.
```

---

## [[0.0.3.0]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.3.0) - 2024-07-18

Github Env Files I think are [limited](https://docs.github.com/en/actions/learn-github-actions/variables#limits-for-configuration-variables) along with the rest of the variables, which means a simple Release Notes document could exceed the maxium 256KB allowed for all variables in a workflow very quickly. This change will check for the existence of a releasenotes document named using a new parameter, the default will be RELEASE.md (assuming we're using the [NewTaggedRelease](https://github.com/mod-posh/NewTaggedRelease) action ). If the file is not found, the action will automatically generate release notes.

What's Changed:

- Added FileName parameter
  - Added logic to validate the file exists
  - If not set GenerateReleseNotes to true
- Removed ReleaseNotes parameter
- PreReleaseNotes changed to boolean and default to false
- Added missing Version parameter

---

## [[0.0.2.15]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.15) - 2024-07-18

BUGFIX: Body should be a required parameter

---

## [[0.0.2.14]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.14) - 2024-01-17

BUGFIX: Invalid json string, trailing quotes after boolean's

---

## [[0.0.2.13]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.13) - 2024-01-17

BUGFIX: Removed the extraneous hashtable update as we're no longer using hashtables.

---

## [[0.0.2.12]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.12) - 2024-01-17

This release fixes the boolean to string issue. PowerShell is casting booleans to strings during the ConvertTo-Json cmdlet, this is causing the GitHub API to throw a 422 error. There were several iterations in an attempt to programatically fix this, but the solution was to simply write the JSON string out manually.

What's Changed

1. Added code to manually construct the json string

---

## [[0.0.2.3]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.3) - 2024-01-17

This release adds some features, you can now set the body of the release, as well as whether or not it's a pre-release and if you want the auto-generated release notes to be added.

What's Changed

1. Added a Body parameter
2. Added a PreRelease parameter, defaults to false
3. Added a ReleaseNotes parameter, defaults to true

---

## [[0.0.2.1]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.1) - 2024-01-17

This release adds some features, you can now set the body of the release, as well as whether or not it's a pre-release and if you want the auto-generated release notes to be added.

What's Changed

1. Added a Body parameter
2. Added a PreRelease parameter, defaults to false
3. Added a ReleaseNotes parameter, defaults to true

---

## [[0.0.2.0]](https://github.com/mod-posh/NewTaggedRelease/releases/tag/v0.0.2.0) - 2024-01-17

This is a breaking change. This release moves from Python to PowerShell for ease of troubleshooting on my end. This release has removed the calculation of the version from the project file. This can be passed either by another action, or script, or manually if need be.

What's Changed

1. Changed the Action to PowerShell
2. Removed Version calculation
3. Added Name and Version inputs
4. Added Verbose for more detailed logging

---
