
#https://github.com/tModLoader/tModLoader/blob/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/Docker/Dockerfile
FROM steamcmd/steamcmd:alpine-3

# Install prerequisites
RUN apk update \
 && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs \
 && rm -rf /var/cache/apk/*
RUN apk add dos2unix 
RUN apk add tmux 

# Fix 32 and 64 bit library conflicts
RUN mkdir /steamlib \
 && mv /lib/libstdc++.so.6 /steamlib \
 && mv /lib/libgcc_s.so.1 /steamlib
ENV LD_LIBRARY_PATH /steamlib

WORKDIR /temp
ADD init_files/Launch.sh .
RUN chmod u+x Launch.sh

ADD init_files/inject.sh . 
RUN chmod u+x inject.sh 

# Create tModLoader user and drop root permissions
ENV UID=1000
ENV GID=1000 
RUN addgroup -g $GID tml \
 && adduser tml -u $UID -G tml -h /home/tml -D
USER tml
ENV USER tml
ENV HOME /home/tml
WORKDIR $HOME

# Update SteamCMD and verify latest version
RUN steamcmd +quit

RUN curl -O https://raw.githubusercontent.com/tModLoader/tModLoader/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/manage-tModLoaderServer.sh \
 && chmod u+x manage-tModLoaderServer.sh \
 && ./manage-tModLoaderServer.sh -i -g --no-mods \
 && chmod u+x $HOME/tModLoader/start-tModLoaderServer.sh

RUN chmod u+x $HOME/tModLoader/LaunchUtils/ScriptCaller.sh

# Download entrypoint script
#RUN curl -O https://raw.githubusercontent.com/tModLoader/tModLoader/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/Docker/Launch.sh \
# && chmod u+x Launch.sh
RUN cp /temp/Launch.sh $HOME
RUN dos2unix $HOME/Launch.sh
RUN cp /temp/inject.sh $HOME/inject
RUN dos2unix $HOME/inject 

ADD init_files/install.txt $HOME 
ADD init_files/enabled.json $HOME/enabled.json
ADD init_files/serverconfig.txt $HOME/serverconfig.txt

ENV PATH="${PATH}:/home/tml"

VOLUME $HOME/.local/share/Terraria

EXPOSE 7777
ENTRYPOINT [ "/bin/bash", "-c", "./Launch.sh" ]
#ENTRYPOINT [ "/bin/bash", "-c", "top" ]
