# Lenny the binoculars

Check your project gemfiles for vulnerable gems.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

## Config vars

- `GITHUB_API_TOKEN` Reads the `Gemfile.lock` and create the statuses
- `GITHUB_KEY` & `GITHUB_SECRET` Oauth app to authenticate
- `GITHUB_ORG` Only users of that org will have acces
- `APP_URL` Used to generate the `target_url` in commit statuses
- `REPOSITORIES` Limit checking to only those repositories

## Screenshots

### Commit status

![](https://dl.dropbox.com/s/t6yrzk266fansqf/Oops_wrong_stuff_by_ys__Pull_Request_2__yslenny-the-binoculars_2016-04-16_12-05-53.png?dl=0)

### Pull request checks

![](https://dl.dropbox.com/s/yet2457vg561j8s/LennyTheBinoculars_2016-04-16_12-06-14.png?dl=0)

## Test

```
$ bin/cibuild
```
