# Pareview.sh Docker

A Docker image for [Pareview.sh](https://www.drupal.org/project/pareviewsh).

## Quickstart

To review a local project:

```bash
$ docker run -it --rm -v "$PWD":/app brambaud/pareviewsh-docker:latest bash -c "./pareview.sh /app" > review.html
```

To review a project using the Git repository:

```bash
$ docker run -it --rm brambaud/pareviewsh-docker:latest bash -c "./pareview.sh http://git.drupal.org/project/rules.git" > review.html
```

