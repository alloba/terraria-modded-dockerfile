# docker build -t terraria-box . 
# docker run -d -n terraria-box-instance terraria-box 

#docker run -d \
# -p 7777:7777 \
# -v ./Terraria_Data:/home/tml/.local/share/Terraria \
# --name terraria-box-instance terraria-box



# docker exec -it terraria-box-instance sh

#FROM alpine 
#WORKDIR /terraria
#RUN apk add --no-cache bash
#RUN apk add --no-cache dos2unix 
#
#RUN mkdir "/data"
#RUN mkdir "/data/terraria-server"
#VOLUME ["/data/terraria-server"]
#
##version is the TAG of the desired release on github. 
#ENV TMODLOADER_VERSION="v2022.09.47.33"  
#RUN wget "https://github.com/tModLoader/tModLoader/releases/download/${TMODLOADER_VERSION}/tModLoader.zip"
#RUN unzip "tModLoader.zip" 
#RUN chmod +x start-tModLoaderServer.sh
#
#ADD provisioning.sh .
#RUN dos2unix provisioning.sh
#
##ENV config= <config file>
#ENV port=7777 
#ENV maxplayers=6 
#ENV password=OnlyFriends
#ENV world=/data/terraria-server/OnlyFriends.wld 
#ENV autocreate=1
#ENV banlist=""                      
#ENV worldname=OnlyFriends
#ENV secure=1       
##ENV steam=1
#ENV lobby=friends  
#ENV announcementboxrange=-1
#ENV seed=05162020
#
##ENTRYPOINT ["top", "-b"]
#ENTRYPOINT ["/bin/bash", "/terraria/provisioning.sh"]





#https://github.com/tModLoader/tModLoader/blob/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/Docker/Dockerfile
FROM steamcmd/steamcmd:alpine-3

# Install prerequisites
RUN apk update \
 && apk add --no-cache bash curl tmux libstdc++ libgcc icu-libs \
 && rm -rf /var/cache/apk/*
RUN apk add dos2unix 

# Fix 32 and 64 bit library conflicts
RUN mkdir /steamlib \
 && mv /lib/libstdc++.so.6 /steamlib \
 && mv /lib/libgcc_s.so.1 /steamlib
ENV LD_LIBRARY_PATH /steamlib

WORKDIR /temp
ADD init_files/Launch.sh .
RUN chmod u+x Launch.sh

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

# Download entrypoint script
#RUN curl -O https://raw.githubusercontent.com/tModLoader/tModLoader/1.4/patches/tModLoader/Terraria/release_extras/DedicatedServerUtils/Docker/Launch.sh \
# && chmod u+x Launch.sh
RUN cp /temp/Launch.sh $HOME
RUN dos2unix $HOME/Launch.sh

ADD init_files/install.txt $HOME 
ADD init_files/enabled.json $HOME/enabled.json
ADD init_files/serverconfig.txt $HOME/serverconfig.txt

VOLUME $HOME/.local/share/Terraria

EXPOSE 7777
#ENTRYPOINT [ "/bin/bash", "-c", "./Launch.sh" ]
ENTRYPOINT [ "/bin/bash", "-c", "top" ]
