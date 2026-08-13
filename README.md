# New Tagged Release

## Overview

The `NewTaggedRelease` GitHub Action is designed to create a GitHub release automatically for you.

## Workflow File

You can trigger the `action.yml` by `workflow_call` to create the release automatically. The workflow contains several steps to act:

1. Checkout the repository
2. Call the `newtaggedrelease.ps1` script

### Workflow Inputs

- `name`: This is the name of the release, if empty, this is set to version
- `version`: This is the version
- `body`: The body of the release
- `prerelease`: Mark this as a pre-prerelease
- `releasenotes`: Add the generated releasenotes
- `verbose`: A value of verbose will output additional information. This input is not required.
- `github_token`: This is the built-in Github Token; this is passed as an environment variable. This input is required.

## PowerShell Script (`newtaggedrelease.ps1`)

The PowerShell script uses the GitHub API to create a release. It parses the project file to determine the version number; this is then assigned to the tag_name and name property of the release.

## Usage

There are a few different ways to use this action; here are a few examples to get you started.

```yaml
permissions:
  contents: write

jobs:
  create_release:
    uses: mod-posh/NewTaggedRelease@v0.0.3.3
    with:
      name: '"Our latest awesome release"'
      version: '"2.0.0"'
      verbose: 'verbose'
      github_token: ${{ secrets.GITHUB_TOKEN }}
```

> [!Important]
> `NewTaggedRelease` needs permission to write repository contents. If the workflow token is missing `contents: write`, GitHub returns a 403/401 and release creation fails.

> [!Note]
> This example is used directly as part of a larger workflow
> The verbose option will output a little more detail in the logs

## License

This project is licensed under the [Gnu GPL-3](LICENSE).
