# TrueNas Custom App Update Script
Since ElectricEel (24.10), my custom apps don't show when there are updates available. (It seems this problem only happens with custom apps created in the UI. Custom Apps via yaml are not affected).

This script checks for updates for running custom apps and updates them if needed. It pulls the latest images and compares them with the currently running ones.

## Usage
Run this script locally on your TrueNAS host. Depending on the user, you may need to use sudo.

```sh
./update.sh [OPTIONS]
```

## Options

* `--check-only` → Pulls new images but does not update any apps.
* `--yes-all` → Updates all outdated apps without asking.

## Examples
Check for updates without applying them:

```sh
./update.sh --check-only
```

Update all outdated apps automatically:
```sh
./update.sh --yes-all
Run the script normally (asks before updating each app):
```
Run the script normally (asks before updating each app):
```sh
./update.sh
```

