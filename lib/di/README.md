# Getting Started

// insert some intro about injectable and why we're using it

## Modules

// Explanation about modules

// Naming Convention

## Dummy Repositories

Both dummy repositories and gRPC-based repositories can be commited into source control, 
each with their own unique filenames. To mark a repository as dummy, add the following annotation;

```dart
@LazySingleton(as: RepositoryName, env: [DiEnvironment.dummy])
```

And for gRPC repositories:

```dart
@LazySingleton(as: RepositoryName, env: DiEnvironment.grpcEnvs)
```

For repositories that can be used in both dummy and gRPC environment, simply leave the `env` argument as null.
Examples are `DeviceNameProvider` and `DeviceFingerprintProvider`.

To quickly toggle between repositories in the whole application, change the env variable `ENABLE_DUMMY_REPOS` in your .env file.

```
# set to false to use gRPC connection
ENABLE_DUMMY_REPOS=TRUE
```

## Disabling Firebase Auth 

Setting up Firebase Auth emulator or a production instance is quite cumbersome and to disable it, set the env variable `ENABLE_FIREBASE_AUTH` to FALSE. By default it is TRUE.

```
ENABLE_FIREBASE_AUTH=FALSE
```

