# Docker base 
FROM ubuntu:bionic

# Create working directory
WORKDIR /usr/src/app

# Install curl and gnupg2 for source file modification
RUN apt-get -y update && apt-get -y install curl gnupg2 ca-certificates software-properties-common xvfb lsb-release \
              libnss3 dbus-x11 libasound2 fluxbox libasound2-plugins alsa-utils alsa-oss pulseaudio pulseaudio-utils \
              && rm -rf /var/lib/apt/lists/* \
              && mkdir download


# Install chrome-stable Node.js
RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add && \
    && curl -sL https://deb.nodesource.com/setup_14.x | bash \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    apt-get -y update && apt-get -y install nodejs google-chrome-stable; apt install -f \
    && rm -rf /var/lib/apt/lists/* 

#Installing all other dependencies 
RUN add-apt-repository ppa:jonathonf/ffmpeg-4 && apt-get -y update && apt-get -y install libgbm-dev \
                       ffmpeg gconf-service libasound2 libatk1.0-0 libc6 libcairo2 \
                       libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 \
                       libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 \
                       libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 \
                       libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 \
                       libxtst6 fonts-liberation libappindicator1 xdg-utils fonts-noto \
                       && rm -rf /var/lib/apt/lists/* 

#copy all files from bbb-mp4 project
COPY *.sh *.js *.json ./ 

#Install npm scripts
RUN npm install npm@latest -g && npm install

#Initialize ENV
ENV REC_URL=" "

# Command that will execute when container starts
ENTRYPOINT ["sh","docker-entrypoint.sh"]
CMD node /usr/src/app/bbb-mp4.js $REC_URL
