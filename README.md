# strava-heatmap-wallpaper

Create your own heatmap from your activities on Strava and set them as Wallpaper. 

## Installation and setup

1. Clone repository 

```
git clone git@github.com:2481632/strava-heatmap-wallpaper.git
```

2. Create python virtual environment

```
python -m venv .venv
```

3. Install dependencies

```
pip install -r requirements.txt
```

4. Obtain strava4_ session cookie

In order to sync your activities you need your Strava session cookie. Log into strava with your favorite webbrowser and use the inspection tool to find the strava4_ cookie. Paste your kookie value into the ```config.yml``` file and copy it into ```~/.config/strava_wallpaper/```.

Now you can execute ```./wallpaper.sh```. When executing the first time your are redirected to strava and have to log in. This is only necessary once. Your image will be saved as ```heatmap.png```.

