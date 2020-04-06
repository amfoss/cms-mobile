## How to Contribute

### Raising an issue:
 This is an Open Source project and we would be happy to see contributors who report bugs and file feature requests submitting pull requests as well.
 This project adheres to the Contributor Covenant code of conduct.
 By participating, you are expected to uphold this code style.
 Please report issues here [Issues - amfoss/cms-mobile](https://gitlab.com/amfoss/cms-mobile/-/issues)

### Branch Policy

#### Sending pull requests:

Go to the repository on GitLab at https://gitlab.com/amfoss/cms-mobile .

Click the “Fork” button at the top right.

You’ll now have your own copy of the original cms-mobile repository in your GitLab account.

Open a terminal/shell.

Type

`$ git clone https://gitlab.com/username/cms-mobile`

where 'username' is your username.

You’ll now have a local copy of your version of the original cms-mobile repository.

#### Change into that project directory (cms-mobile):

`$ cd cms-mobile`

#### Add a connection to the original cms-mobile repository.

`$ git remote add upstream https://gitlab.com/amfoss/cms-mobile`

#### To check this remote add set up:

`$ git remote -v`

#### Make changes to files.

`git add` and `git commit` those changes

`git push` them back to GitLab. These will go to your version of the repository.


#### Now Create a PR (Pull Request)

Go to your version of the repository on GitLab.

Click the “New pull Request” button at the top.

Click the green button “Create pull request”. Give a succinct and informative title, in the comment field give a short explanation of the changes and click the blue button “Create pull request” again.

#### Pulling others’ changes

Before you make further changes to the repository, you should check that your version is up to date relative to original version.

Go into the directory for the project and type:

`$ git checkout <branch under development>`

`$ git pull upstream <branch under development> --rebase`

This will pull down and merge all of the changes that have been made in the original cms-mobile repository.

Now push them back to your GitLab repository.

`$ git push origin <branch under development>`
