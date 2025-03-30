#!/bin/bash

CHECK_ONLY=false
YES_ALL=false

for arg in "$@"; do
    case $arg in
        --check-only)
            CHECK_ONLY=true
            ;;
        --yes-all)
            YES_ALL=true
            ;;
    esac
done

apps_json=$(midclt call app.query)
apps=$(echo "$apps_json" | jq --raw-output '.[] | select(.metadata.categories[]? == "custom" and .state == "RUNNING") | .name')

for app in $apps; do

  image=$(echo "$apps_json" | jq --raw-output '.[] | select(.name == "'$app'") | .active_workloads.container_details[0].image')
  container_id=$(echo "$apps_json" | jq --raw-output '.[] | select(.name == "'$app'") | .active_workloads.container_details[0].id')
  echo "----------------------------------------"
  echo "Checking for updates for $app"
  echo "Image: $image"
  echo "Container ID: $container_id"

  # Get the image ID of the running container
  current_id=$(docker inspect --format '{{.Image}}' $container_id)
  # Pull the latest image from the registry
  docker pull "$image" > /dev/null 2>&1
  latest_id=$(docker inspect --format '{{.Id}}' $image 2>/dev/null)

  echo "Current ID: $current_id"
  echo "Latest  ID: $latest_id"

  # Compare image IDs
  if [ "$current_id" != "$latest_id" ]; then
    echo "Update available for $app_name ($image)."

    if $CHECK_ONLY; then
      echo "Skipping update due to --check-only flag."
      continue
    fi

    if $YES_ALL; then
      echo "Updating $app..."
      midclt call app.redeploy "$app"
      continue
    fi
    echo "Do you want to update? (y/n)"
    read answer
    if [[ "$answer" == "y" ]]; then
      echo "Updating $app..."
      midclt call app.redeploy $app
    fi
  else
      echo "$app up to date!"
  fi
done