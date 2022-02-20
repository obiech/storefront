# storefront-app

Dropezy Storefront mobile app developed in Flutter.

# Getting started

## Setting up Environment Variables

Environment variables are loaded using [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) package. 

Create a file named `env/.env` in your local repository. This file should not be commited and
is added into `.gitignore`.

To quickly setup your local environment, copy the `env.example` file with this command:

```
$ cp ./env/.env.example ./env/.env
```

Then make changes as necessary.


In the Flutter App, all references to environment variables are placed in classes inside `lib/constants/config` directory 
and divided according to their domain for easier maintenance.
