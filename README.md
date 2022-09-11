# m3u82mp3 - A soundcloud m3u playlist downloader
![](./Demo.gif)
> *A quick bash script to download Soundcloud [HSL](https://en.wikipedia.org/wiki/HTTP_Live_Streaming) `.playlist.m3u8` files*
## Features
- Download basic M3U playlist chunks and convert them into an .mp3 (only mp3 tracks are supported)
## Alternatives 

To download tracks directly from a soundcloud UI you please see this browser extension made by @Tenpi, checkout: [soundcloud-download](https://github.com/Tenpi/soundcloud-download)

## Install: GNU/Linux
Drop this script into an appropriate folder like `/usr/bin` or local `$HOME/bin`, or uset from `.{bash,zsh}rc` file:

### Basher
See [basher](https://github.com/basherpm/basher) package manager

```bash
    basher install --ssh hinell/soundcloud-m3u82mp3
```

### Directly
Run in your shell:
```bash
    INSTALL_PATH=${HOME}/.bash/m3u82mp3/m3u82mp3.sh
    [ -s "${INSTALL_PATH}" ] && { 
        echo "Already installed: $INSTALL_PATH"
    } || {
        mkdir -p "${HOME}/.bash/m3u82mp3"
        curl -L "https://github.com/hinell/soundcloud-m3u82mp3/raw/main/m3u82mp3.bash" > ${INSTALL_PATH}
        chmod a+=rwx ${INSTALL_PATH}
        sudo ln -s ${INSTALL_PATH} /usr/bin/
        echo "Script is installed into ${INSTALL_PATH}"
    }
    unset INSTALL_PATH
    
```
 
## Uninstall

See [basher](https://github.com/basherpm/basher) package manager

```bash
    basher uninstall hinell/soundcloud-m3u82mp3
```

### If installed by curl:
```bash
    rm ${HOME}/.bash/m3u82mp3/m3u82mp3.sh
    sudo unlink /usr/bin/m3u82mp3.sh
```

## Usage
In order to use, you have to obtain a m3u8 playlist url. Use your browser devtools and navigate to soundcloud track page, hit F12, and navigate to a network tab. There you can filter out m3u8 playlists and copy link

The following code demostrates how to download chunks of a given m3u8 playlist url and concatenate them under a given song name:
<br/>**NOTE**: the URL below may fail!

```bash
$ songName='Henrik Meierkord - Stringdrone'
$ ./m3u82mp3.bash "$songName" <<<'https://cf-hls-media.sndcdn.com/playlist/lDzm81Tsundg.128.mp3/playlist.m3u8?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiKjovL2NmLWhscy1tZWRpYS5zbmRjZG4uY29tL3BsYXlsaXN0L2xEem04MVRzdW5kZy4xMjgubXAzL3BsYXlsaXN0Lm0zdTgqIiwiQ29uZGl0aW9uIjp7IkRhdGVMZXNzVGhhbiI6eyJBV1M6RXBvY2hUaW1lIjoxNjYyMDY2MTI1fX19XX0_&Signature=WbBqYAvZp30wAHcvDwCEDunf9RyrhBXfLxQ9Ys~aLa1ZauIFAoZ-iVGZpro63OQunLs9bIWe3wGh~-Vqc7NgmJEcs0-j5ySUVdKzzIr0MF3hcSmvWz6uLygJjJHDRN39U1w8Euq0hFP6anDHjefy-EIlBmGIYCUP6gH~rhkgCaKK63B3gCaq~srnE4aAh6bfoy8Teh-FHwJ~CTHameU697RH3jHxhAxRFk8PrmKq0mBO24YNTYBEWcNhaH-gQqZjrXNHxBzXf3joPKInp5~y7PHGmD3Wpm34flCkNbGdPyiLp0XW~QCVOdxufmxG0y4qpJB0VMt1ZTqobeDT1F1hGQ__&Key-Pair-Id=APKAI6TU7MMXM5DG6EPQ&track_authorization=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJnZW8iOiJSVSIsInN1YiI6IjM4ODU0NDMwIiwicmlkIjoiNTNhOTY2YzMtMDYwMy00OTAxLTljZTgtMjFhZWIyZDVlZWM0IiwiaWF0IjoxNjYyMDY1OTA2fQ.hccxwerMuzZpbOzYbKDEUnUrES-NGzRBJdptvEjZ4iQ'

$ xdg-open "$songName.mp3"
 ```
## CLI

```bash
# # URL to an playlist can be obtained from Browser devTools 
$ URL="https://..."
$ m3u82mp3 <songName> <<<"$URL" 
```
- **URL** - https://... etc
- **Output**: ./&lt;songName>.mp3


## License
*See [LICENSE](LICENSE) for full FOSSIL license.*


## Development
It uses `curl` under the hood and stores its files int the `/tmp` folder.

----
```
m3u82mp3 - A soundcloud m3u playlist downloader
See LICENSE file (or comment at the top of the files)
provided along with the source code for additional info
Copyright (C) 2022- Alex A. Davronov <al.neodim@gmail.com>
Learn more about script here https://github.com/hinell
```
> September 01, 2022