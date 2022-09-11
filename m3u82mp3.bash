#!/usr/bin/env bash

# Title.......: m3u82mp3
# Summary.....: Downloads .m3u8 playlists from soundcloud
# Version.....: 1.0.0
# Created.....: September 01, 2022 
# Authors.....: Alex A. Davronov <al.neodim@gmail.com> (2022-)
# Repository..: N/A
# Description.: The CLI tool to download .m3u playlist automatically
# Usage.......: See README.md

# TODO: Add comments
# @para {trackName} - Track name 
# @para {url}       - URL or filepath to a M3U playlist
m3u82mp3(){
    local trackName="${1?'Please, specify file name .e.g''\'Artist - My song\\''}"
    [[ -s "$trackName.mp3" ]] && {
      echo "Skip: file already exists: '$trackName.mp3'";
      return -1;
    }
    
    echo "Please, specify playlist <filePath> or <url> (e.g. https://hls.com/playlist.mp3u8)} for"
    echo "$trackName :"
    read source
    local playlistPath=""; # Playlistfile path
    echo "The following playlist is specified:"
    echo $source
    
    # If URL is specified - download and use as a playlist
    # otherwise use specified file
    local httpUrlRe=$'^http(s)?://'    
    local m3uPlaylistExt=$'^(http(s)?://.*\.m3u8)'

    if [[ "$source" =~ $httpUrlRe ]];
    then
        [[ "$source" =~ $m3uPlaylistExt ]] ||
        {
            echo "Error: invalid url, failed to recognize .m3u8 extension" 2&> /dev/stderr;
            return -1;
        }
        
        playlistPath="/tmp/${trackName}.playlist.m3u8";
        curl -s -w "%{stderr}#$(date)\nCURL_ERROR=%{errormsg}\nCURL_HTTP_RESPONSE_ERR=%{http_code}\nCURL_EC=%{exitcode}\n----\n" -o "$playlistPath" "$source" 2> 'curl.log' || {
            echo "Aborting: failed to download the plalist from <URL>:"
            echo "$source"
            return -1;
        }
        
        [[ `du "$playlistPath" | cut -f 1` -lt 8 ]] && {
            echo "Aborting: curl has failed to download the playlist. curl.log:"
            cat curl.log
            return -1;
        }
        
    else
        [[ -r "$source" ]] ||  {
            echo 'Error: playlist $file is not found' 2&> /dev/stderr;
            return -1;
        }
        
        [[ -s "$source" ]] ||  {
            echo 'Error: playlist is empty' 2&> /dev/stderr
            return -1;
        }
        
        playlistPath="$source"
    fi
    
    local -a M3UArr=();
    local -a tracks=();
    local -i i=0;
    while read line; do
        M3UArr+=($line);
        [[ -v saveNext ]] && {
            tracks+=($line)
            unset saveNext;
        }
        [[ "$line" =~ \#EXTINF:* ]] && saveNext=1;
        ((i++));
    done < "$playlistPath"
    
    # local -p tracks
    # 
    local -i i=1;
    local concatList='concat:'
    for track in ${tracks[@]}; do
        curl "$track" -s -o "/tmp/chunk$i.mp3" || {
            echo "Aborting: failed to download $track"
            return -1
        }
        echo "downloading ${track:0:80}..."
        concatList+="/tmp/chunk$i.mp3|"
        ((i++));
    done
    echo "Total downloaded: $(du -hcs *.mp3 | tail -1 | cut -f 1)"
    
    ffmpeg -i "${concatList%%|}" -c copy "$trackName.mp3" \
    && echo "Done: "$trackName.mp3""
    
    rm "/tmp/chunk$i.mp3"
}

m3u82mp3 "${@}"

# Reads lines (<SongName>|<url>)
# from specified file and runs m3u82mp3 against every one
m3u82mp3.fromList(){
  echo "Expected file format:"
  echo "<SongName>|<url>"
  
  local listFileName=${1?"File name is not specified"}
  local -a entry=()
  local fileName=""
  local url=""

  while read line; do
  
      #TODO: update for bash
      # This is only for zsh
      IFS='|' entry=("${(ps.|.)line}")
      
      fileName=${entry[1]}
      url=${entry[2]}
      m3u82mp3 "$fileName" <<<"$url" 
      
  done < "$listFileName"
}
