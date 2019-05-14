#!/bin/bash

# Exit on error
set -e

# Stash org UUID
ORG_UUID="75553157-c4b5-444b-bd0b-036fb9ca6d98"

# Stash list of all Pantheon sites in the org
PANTHEON_SITES="$(terminus org:site:list -n ${ORG_UUID} --format=list --field=Name)"
# echo $PANTHEON_SITES

# Function: Get each site environment's id and append to PANTHEON_SITE_NAME, e.g. dev, test, live, multidev
get_site_environments() {
  # Get list of site environments
  site_name=$1

  #Get each site's environment
  PANTHEON_SITE_ENVIRONMENTS="$(terminus env:list $site_name --field=id)"
  
  # Loop through each site env
  # append to $site_name as site.env
  # export each site.env to be used later to get custom domains from each env—could also test if there are any first. 
  for ENV in "$PANTHEON_SITE_ENVIRONMENTS"
  do
    #Issue: For each $ENV, create a $site_name.$ENV. This loop only does it on the first one. 
    # need to get to apply to all environments in $ENV
    echo "$site_name.$ENV"
    return 0
  done
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
        # echo -e "Adding '$PANTHEON_SITE_NAME' to the list."
    
        get_site_environments $PANTHEON_SITE_NAME
        #echo $site_name
    fi
done <<< "$PANTHEON_SITES"



