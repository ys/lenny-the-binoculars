# Lenny the binoculars

Check your project gemfiles for vulnerable gems.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## How-to?

- Deploy to Heroku
- Add repos from the homepage in the format of `owner/repo1,owner/repo3`
- Send pull-request webhooks to `"#{ENV["APP_URL"]}/webhooks"`

## Config vars

- `GITHUB_API_TOKEN` Reads the `Gemfile.lock` and create the statuses
- `GITHUB_KEY` & `GITHUB_SECRET` Oauth app to authenticate
- `GITHUB_ORG` Only users of that org will have acces
- `APP_URL` Used to generate the `target_url` in commit statuses

## Setup

```
$ bin/setup
```

## Test

```
$ bin/cibuild
```

## Screenshots

### Index

![](https://dl.dropbox.com/s/md9futx11f37t4f/LennyTheBinoculars_2016-04-16_12-37-59.png?dl=0)

### Commit status

![](https://dl.dropbox.com/s/t6yrzk266fansqf/Oops_wrong_stuff_by_ys__Pull_Request_2__yslenny-the-binoculars_2016-04-16_12-05-53.png?dl=0)

### Pull request checks

![](https://dl.dropbox.com/s/yet2457vg561j8s/LennyTheBinoculars_2016-04-16_12-06-14.png?dl=0)

