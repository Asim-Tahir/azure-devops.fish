<img src="https://cdn.rawgit.com/oh-my-fish/oh-my-fish/e4f1c2e0219a17e2c748b824004c8d0b38055c16/docs/logo.svg" align="left" width="192px" height="192px"/>
<img align="left" width="0" height="192px" hspace="10"/>

### `azure-devops.fish`

> `Azure DevOps` plugin for [Oh My Fish][omf] and [Fisher][fisher],

[![MIT License](https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square)](/LICENSE)
[![Fish Shell v3.6.0](https://img.shields.io/badge/fish-v3.6.0-007EC7.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-007EC7.svg?style=flat-square)][omf]

<br/><br/>

## Install

[Oh My Fish][omf]:

```sh
omf install https://github.com/Asim-Tahir/azure-devops.fish
```

[Fisher][fisher]:

```sh
fisher install Asim-Tahir/azure-devops.fish
```

## Usage

After installing the [`azure-devops.fish`][repo] plugin, can use the functions with the following command:

### Get Azure DevOps Pull Request URL

#### Basic Usage

The `azure-devops.pr-url` function helps you quickly get the URL of your Azure DevOps pull request. It works in any git repository connected to Azure DevOps.

```fish
azure-devops.pr-url
# Output: https://dev.azure.com/organization/project/_git/repository/pullrequestcreate?sourceRef=feature-branch&targetRef=main
```

#### Arguments

##### Help (`-h`, `--help`)
Display help information:

```fish
azure-devops.pr-url --help
# or
azure-devops.pr-url -h
```

##### Git Remote Name (`-r`, `--git-remote`)

Specify the Git remote name:

```fish
azure-devops.pr-url --git-remote "upstream"
# or
azure-devops.pr-url -r "origin"
```

Default: `$AZURE_DEVOPS_FISH_GIT_REMOTE` or "origin"


##### Git Remote URL (`-R`, `--git-remote-url`)
Provide the Azure DevOps repository URL directly:

```fish
azure-devops.pr-url --git-remote-url "https://dev.azure.com/MyOrg/MyProject/_git/MyRepo"
# or
azure-devops.pr-url -R "git@ssh.dev.azure.com:v3/MyOrg/MyProject/MyRepo"
```

Default: `$AZURE_DEVOPS_FISH_GIT_REMOTE_URL` or URL from specified git remote

##### Source Branch (`-s`, `--source-branch`)
Set the source branch for the PR:
```fish
azure-devops.pr-url --source-branch "feature/new-feature"
# or
azure-devops.pr-url -s "bugfix/issue-123"
```

Default: `$AZURE_DEVOPS_FISH_SOURCE_BRANCH` or current branch

##### Target Branch (`-t`, `--target-branch`)

Set the target branch for the PR:

```fish
azure-devops.pr-url --target-branch "main"
# or
azure-devops.pr-url -t "develop"
```

Default: `$AZURE_DEVOPS_FISH_TARGET_BRANCH` or git default branch

#### Example Usage

1. Basic usage with default values:
```fish
azure-devops.pr-url
```

2. Specify target branch only:
```fish
azure-devops.pr-url -t "main"
```

3. Custom source and target branches:
```fish
azure-devops.pr-url -s "feature/my-awesome-feature" -t "develop"
```

4. Using different git remote with target branch:
```fish
azure-devops.pr-url -r "upstream" -t "main"
```

5. Full example with all arguments:
```fish
azure-devops.pr-url \
    -s "feature/my-awesome-feature" \
    -t "main" \
    -R "https://My_Org@dev.azure.com/My_Org/My%20-%20Project/_git/My.Repo"
```

### Get Azure DevOps Work Item URL

The `azure-devops.workitem-url` function returns the direct URL to a specific Azure DevOps work item.

#### Basic Usage

```fish
azure-devops.workitem-url -o "MyOrganization" -p "MyProject" -w 12345
# Output: https://dev.azure.com/MyOrganization/MyProject/_workitems/edit/12345
```

#### Arguments

- `-h`, `--help`           Show help message
- `-o`, `--organization`   Azure DevOps organization name (required)
- `-p`, `--project`        Azure DevOps project name (required)
- `-w`, `--workitem`       Azure DevOps work item ID (required, positive integer)

#### Example

```fish
azure-devops.workitem-url -o "MyOrganization" -p "MyProject" -w 12345
```

If you have set the following environment variables, you can omit the arguments:
- `AZURE_DEVOPS_FISH_ORGANIZATION`
- `AZURE_DEVOPS_FISH_PROJECT`
- `AZURE_DEVOPS_FISH_WORKITEM`

```fish
set -x AZURE_DEVOPS_FISH_ORGANIZATION "MyOrganization"
set -x AZURE_DEVOPS_FISH_PROJECT "MyProject"
set -x AZURE_DEVOPS_FISH_WORKITEM 12345
azure-devops.workitem-url
```

If any required argument is missing or invalid, the function will print an error and usage example.

### Environment Variables

#### Input Enviroment Variables

- `AZURE_DEVOPS_FISH_GIT_REMOTE`: Git remote name
- `AZURE_DEVOPS_FISH_GIT_REMOTE_URL`: Git remote URL
- `AZURE_DEVOPS_FISH_SOURCE_BRANCH`: Source branch
- `AZURE_DEVOPS_FISH_TARGET_BRANCH`: Target branch

- `AZURE_DEVOPS_FISH_ORGANIZATION`: Azure DevOps organization name
- `AZURE_DEVOPS_FISH_PROJECT`: Azure DevOps project name
- `AZURE_DEVOPS_FISH_WORKITEM`: Azure DevOps work item ID

#### Output Environment Variables

- `AZURE_DEVOPS_FISH_PULL_REQUEST_URL`: Azure DevOps Pull Request URL
- `AZURE_DEVOPS_FISH_WORKITEM_URL`: Azure DevOps Work Item URL

# Credit

Base structure heavily inspired from [`jhillyerd/plugin-git`](https://github.com/jhillyerd/plugin-git). Thanks for the amazing plugin.

# License

[MIT][license] © [Asim Tahir][author]

[author]: https://github.com/Asim-Tahir
[repo]: https://github.com/Asim-Tahir/azure-devops.fish
[license]: https://opensource.org/licenses/MIT
[omz]: https://github.com/ohmyzsh/ohmyzsh
[omf]: https://github.com/oh-my-fish/oh-my-fish
[fisher]: https://github.com/jorgebucaran/fisher
[license-badge]: https://img.shields.io/badge/license-MIT-007EC7.svg?style=flat-square
