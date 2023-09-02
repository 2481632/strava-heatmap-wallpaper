#!/usr/bin/env bash

# colors
RED='\033[0;31m'
NC='\033[0m' # No Color

# Make sure sqlite3 is installed 
if ! command -v sqlite3 &> /dev/null
then
    echo "sqlite3 could not be found. Please install sqlite3 and try again."
    exit
fi

# Check if strava-offline is installed
if ! command -v strava-offline &> /dev/null
then
    echo "strava-offline could not be found. Execute pip install -r requirements.txt to install dependencys and see README.md."
    exit
fi

# Check if gpsbabel is installed
if ! command -v gunzip &> /dev/null
then
    echo "gunzip could not be found. Please install gunzip and try again."
    exit
fi

BASEDIR=${XDG_CONFIG_HOME:-~/.config}/strava_wallpaper/
DATABASE=${XDG_CONFIG_HOME:-~/.config}/strava_wallpaper/strava.sqlite
ACTIVITIES=~/.local/share/strava_wallpaper/activities/
CONFIG=${XDG_CONFIG_HOME:-~/.config}/strava_wallpaper/config.yml

mkdir -p $BASEDIR
mkdir -p $ACTIVITIES

# Chack if database was being created
if ! test -f $CONFIG; then
    echo -e "${RED}Config file not found.${NC}"
    echo "Copy the sample config.yml file to $BASEDIR. You can use the following command to do this:"
    echo "> cp config.yml $BASEDIR"
    exit
fi

# Create database of activities
# This will open a webbrowser where the user has to login in order to obtain a copy of activities. 
strava-offline sqlite --database $DATABASE

# Chack if database was being created
if ! test -f "$DATABASE"; then
    echo "$DATABASE Database file does not exist. Login failed?"
    exit
fi

# Remove virtual rides
sqlite3 $DATABASE "DELETE FROM activity WHERE NOT type = 'Ride' OR type = 'Run'"

# Downloading activities
echo "Download activities. This might take a while..."
# strava-offline gpx --database $DATABASE --dir-activities $ACTIVITIES --config $CONFIG

# Extract gz files
echo "Extract activities..."
count=`ls -1 $ACTIVITIES/*.gz 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
    gunzip $ACTIVITIES/*.gz
fi 

# Check if activities are in fit format and convert them. 
count=`ls -1 $ACTIVITIES/*.fit 2>/dev/null | wc -l`
if [ $count != 0 ]
then 
    # Check if gpsbabel is installed
    if ! command -v gpsbabel &> /dev/null
    then
        echo "[WARNING] gpsbabel could not be found but you have activities in the fit format. These activities will not be included on your map. Please install gpbabel and try again if activities are missing. "
    fi
    for file in $ACTIVITIES*.fit; do gpsbabel -i garmin_fit -f "${file}" -o gpx -F "${file}.gpx"; done
fi 

# Create image
python ./strava_local_heatmap.py --dir $ACTIVITIES
echo "Your heatmap has been saved to $PWD/heatmap.png" # TODO: Check if image was written successfully
