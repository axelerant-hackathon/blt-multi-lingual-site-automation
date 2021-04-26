# prerequisite
1. Setup lando locally.
    We are using lando based setup for the local environment. Install the lando from [here](https://github.com/lando/lando)

# Getting Started
This project is based on BLT 12.x with Lando local env, an open-source project template and tool that enables building, testing, and deploying Drupal installations following Acquia Professional Services best practices. While this is one of many methodologies, it is our recommended methodology.

1. Review the [Required / Recommended Skills](https://docs.acquia.com/blt/developer/skills/) for working with a BLT project.
2. Ensure that your computer meets the minimum installation requirements (and then install the required applications). See the [System Requirements](https://docs.acquia.com/blt/install/).

# Local setup of project
`1.` Clone your repository. By default, Git names this "origin" on your local.
```
$ git clone git@gitorious.xyz:saqa/qa-hackathon.git
```


`2.` Install Composer dependencies.
After cloned the project, go to cloned directory. (Warning: this can take some time based on internet speeds.)
`Note: If you are using composer 2 then ignore some error related to hirak/xyz plugin.`
```
$ composer install
```

`3.` Setup Lando.
Setup the container by modifying your .lando.yml  with the configuration from this repositories [configuration files](#important-configuration-files).
```
$ lando start
```
`4` Initializing BLT
```
blt recipes:vm:lando
```
```
Note: After executing above command, content from README file wll get change on your local. Please ignore this and dont commit this file. If you want to do changes in this file then first checkout this file, do changes and then push this file.
```

`5.` Use BLT to setup the site with configuration.  If it is a multisite you can identify a specific site.
```
$ lando blt setup
```

`6.` Log into your site with drush.
Access the site and do necessary work at #LOCAL_DEV_URL by running the following commands.
```
$ cd docroot
$ lando drush uli
```

`7.` Trigger “blt” command, it will give you whole list of blt commands

`8.` To copy Example Behat tests in your application. Go to root directory(qa-hackathon) and then trigger below command
```
lando blt recipes:behat:init
```

`9.` To run example behat test, trigger below command from root directory (qa-hackathon)
```
lando blt tests:behat:run
```
```
Note: while excuting this command, It will give the following step where we need to proceed with "y" .
BLT can (re)generate tests/behat/local.yml using tests/behat/example.local.yml. Do you want (re)generate local Behat config in tests/behat/local.yml? (y/n)
```

---
# To start developing every time

First add remote to trigger push and pull command
```
$ git remote add origin https://github.com/user/repo.git
# Set a new remote

$ git remote -v
# Verify new remote
> origin  https://github.com/user/repo.git (push)
```

1. Pull from the github repository
```
git pull origin develop
```

2. Create a new feature branch from develop
```
git checkout -b JIRA-000-feature-branch
```

### To Create a Pull Request.

`1.` After you make changes inside your local drupal site. Export your configuration from the database to your configuration.
 Export your drupal config changes if you have them.
 ```
$ lando drush cex
```

`2.` commit your changes and push your changes to your origin repository.
```
$ git status
$ git add <file_name(s)>
$ git commit -m "qa-hackathon-000: Committing new changes to site."
$ git push origin <branch_name>
```

`3.` Navigate to Github and open a pull request against the upstream. Assign a person on your team to review.

# Resources

Additional [BLT documentation](https://docs.acquia.com/blt/) may be useful. You may also access a list of BLT commands by running this:
```
$ blt
```

Note the following properties of this project:
* Primary development branch: Develop
* Local site URL: http://qa-hackathon.lndo.site

## Working With a BLT Project
BLT projects are designed to instill software development best practices (including git workflows). \
Our BLT Developer documentation includes an [example workflow](https://docs.acquia.com/blt/developer/dev-workflow/).

### Important Configuration Files
BLT uses a number of configuration (`.yml` or `.json`) files to define and customize behaviors. Some examples of these are:

* `blt/blt.yml` (formerly blt/project.yml prior to BLT 9.x)
* `blt/local.blt.yml` (local only specific blt configuration)
* `lando.yml` (Lando configuration)
* `drush/sites` (contains Drush aliases for this project)
* `composer.json` (includes required components, including Drupal Modules, for this project)
