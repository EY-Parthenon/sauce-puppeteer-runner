FROM saucelabs/testrunner-image:latest

#================
# Install Node.JS
#================
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash \
  && export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")" \
  && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" \
  && nvm install 12.16.2

ENV PATH="/home/seluser/bin:/home/seluser/.nvm/versions/node/v12.16.2/bin:${PATH}" \
    CHROME_BINARY_PATH="/usr/bin/google-chrome-stable" \
    WDIO_LOG_PATH="/home/seluser/docker.log"

WORKDIR /home/seluser

RUN curl -L -o saucectl-internal_0.4.1_linux_64-bit.tar.gz \
  -H 'Authorization: token 3b7322d6d66db64750809c1e2a0162a0e8b124c0' \
  -H "Accept: application/octet-stream" \
  https://api.github.com/repos/saucelabs/saucectl-internal/releases/assets/20466049 \
  && tar -xvzf saucectl-internal_0.4.1_linux_64-bit.tar.gz \
  && mkdir /home/seluser/bin/ \
  && mv ./saucectl-internal /home/seluser/bin/saucectl

COPY package.json .
RUN npm install
COPY . .
RUN sudo chown -R seluser /home/seluser

#==================
# ENTRYPOINT & CMD
#==================
# IMPORTANT: Using the string form `CMD "entry.sh"` without
# brackets [] causes Docker to run your process
# And using `bash` which doesn’t handle signals properly
CMD ["./entry.sh"]
