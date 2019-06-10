#!/usr/bin/env bash

readarray -t lines < <(lsblk --nodeps -no name | grep "sd")

echo "Please select a drive:"
select choice in "${lines[@]}"; do
  [[ -n $choice ]] || { echo "Invalid choice. Please try again." >&2; continue; }
  break # valid, proceed
done

read -r id sn unused <<<"$choice"

echo "id: [$id]; s/n: [$sn]"