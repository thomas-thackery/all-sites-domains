#!/bin/bash

# Exit on error
set -e

# Stash org UUID
ORG_UUID="75553157-c4b5-444b-bd0b-036fb9ca6d98"

# Stash list of all Pantheon sites in the org
PANTHEON_SITES="$(terminus org:site:list -n ${ORG_UUID} --format=list --field=Name)"
echo $PANTHEON_SITES

# Function: Get each site environment's id and append to PANTHEON_SITE_NAME, e.g. dev, test, live, multidev
get_site_environments() {
  # Get list of site environments
  site_name=$1
  PANTHEON_SITE_ENVIRONMENTS="$(terminus env:list $site_name --field=id)"
  echo $PANTHEON_SITE_ENVIRONMENTS
  # Loop through each site env
  # append to $site_name
  # return $site_name
  # output should be site.env
  
  #echo -e $PANTHEON_SITE_ENVIRONMENTS
  return $1

}


# Loop through each site in the list
while read -r PANTHEON_SITE_NAME; do
    # Check if the site is frozen
    IS_FROZEN="$(terminus site:info $PANTHEON_SITE_NAME --field=frozen)"

    # If the site is frozen
    if [[ "true" == "${IS_FROZEN}" ]]
    then
        # Then skip it
        echo -e "Skipping '$PANTHEON_SITE_NAME' because it is frozen.\n"
    else
        # Otherwise add the site to the list
        echo -e "Adding '$PANTHEON_SITE_NAME' to the list."
        
        # Needs work here. Getting error when calling this function  
        get_site_environments $PANTHEON_SITE_NAME
      
    fi
done <<< "$PANTHEON_SITES"



