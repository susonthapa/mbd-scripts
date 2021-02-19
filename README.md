# mbd-scripts
Script to help faciliate various tasks for modular project with submodules(specific to our current project)

### Installation

#### Clone
Clone the project and then create symbolic links for the commands and place it in your path. For linux you can create symbolic link with
```
ln -s location_of_script /usr/local/bin/script_name
```
I have used `/usr/local/bin` which is a good place for your own script that can be accessed by multiple users. For simplicity I like to prefix the symoblic link with `mbd` so that it's easy to autocomplete like `mbd-start-task` for `start-task.sh` script and so on.

#### Kotlin
You need to install kotlin in order to use the auto version increment. Search for kotlin installation for your particular Operation System(not supported for windows).

### Expected workflow
This script is highly opinionated based on my workflow. I assume that you are on the root of your project. The expected workflow is explained below. 

#### Start task
```
mbd-start-task branch_name
```
  - Checks out develop branch
  - Pulls the latest changes
  - Create a new branch

Repeats the above process for `features` and `libraries` submodules.

#### End task
```
mbd-end-task
```
  - Checks out develop branch
  - Pulls the latest changes
  - Checks out the feature branch
  - Peforms rebase (might fail in which case you have to continue yourself)

Repeats the above process for  `features` and `libraries` submodules.

#### Version task
**Note:** This task is assumed to be executed only once during the completion of the task. If for some reason you need increase the version try to do it manually.

For this task to execute you have to create a script `mbd-version-task` (or any name) with the following content and put it in your path.
```
#!/bin/bash
path-to-version-task.sh path-to-versions.jar
```
Then execute the command like below.
```
mbd-version-task
```
This task peform following operations.
##### Features submodule
  - Update the versions of the changed modules
  - Add the commit including the updated versions
  - Forces push the changes
##### Libraries submodule
Same as above.
##### App layer
  - Grabs the latest appcore version from `features` submodule
  - Update the version of the appcore to the latest version
  - Add the commit including the updated appcore version
  - Force push the changes
 
### Switch task
When you have to switch between different branches, there is a helper script for that with autocompletion for branch names.
Edit your `.bashrc`(or other file based on your shell) and add the following to enable autocompletion.
 ```
# source custom bash completion for mbd script
source path-to-mbd-script-completion.bash
```
#### Normal switch task
```
  mbd-switch-task branch_name
```
Switches the branches of root as well as submodules. Assumes that the working directory is clean.
#### Hard switch task
```
mbd-switch-hard branch_name
```
Resets the current working directory before switching branches. Use with **Caution**
