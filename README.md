WGRIB2 on Container (Debian) with Python 3.8

## Dockerhub: 
`docker pull sondngyn/wgrib2:python38`

## USAGE

### Usage:

#### Docker-Compose CLI
Create `.env` file from `.env.dist` and change the env values to the dirs location on your computer (for windows, use `/c/abs/path/`)
`docker-compose build wgrib2`
`docker-compose up wgrib2` (change `command` in docker-compose file to your script filename before running `up`)

#### Docker CLI
`docker build -t wgrib2 .`
##### On Linux:
`docker run -v /path/to/data:/srv/ -v /path/to/script:/opt/ wgrib2 /opt/script_file_name.sh`
##### On Windows: 
*Note:
Remember to put `#!bin/bash` in the beginning of your script file
Make sure your script file uses LF (Linux line break types) instead of CRLF (Windows)
`docker run -v C:\\absolute\\path\\:/srv/ -v C:\\absolute\\path\\:/opt/ wgrib2 script_file_name.sh`
(watch out for back-slashes and forward-slashes)
### Example on Windows (powershell): 
`docker run -v C:\\Users\\myuser\\mydata\\:/srv/ -v C:\\Users\\myuser\\myscript\\:/opt/ wgrib2 myscript.sh`
