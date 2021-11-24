FROM python:3.7.5

# apt-get installs
RUN apt-get update -yqq && apt-get install apt-transport-https zip -yqq &&  apt-get upgrade -yqq 

# Install Chrome WebDriver
RUN CHROME_DRIVER_VERSION=`curl -sS http://chromedriver.storage.googleapis.com/LATEST_RELEASE` && \
    echo Creating dir: /opt/chromedriver-$CHROME_DRIVER_VERSION && \
    mkdir -p /opt/chromedriver-$CHROME_DRIVER_VERSION && \
    echo Getting chromedriver linux executable from: http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    echo to: /tmp/chromedriver_linux64.zip && \
    curl -sS -o /tmp/chromedriver_linux64.zip http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip && \
    echo Unzipping: /tmp/chromedriver_linux64.zip to: /opt/chromedriver-$CHROME_DRIVER_VERSION && \
    unzip -qq /tmp/chromedriver_linux64.zip -d /opt/chromedriver-$CHROME_DRIVER_VERSION && \
    echo Removing unnecessary zip file: /tmp/chromedriver_linux64.zip && \
    rm /tmp/chromedriver_linux64.zip && \
    echo Adding permissions to: 'chromedriver' at: /opt/chromedriver-$CHROME_DRIVER_VERSION/chromedriver && \
    chmod +x /opt/chromedriver-$CHROME_DRIVER_VERSION/chromedriver && \
    echo Creating link from: /opt/chromedriver-$CHROME_DRIVER_VERSION/chromedriver to: /usr/local/bin/chromedriver && \
    ln -fs /opt/chromedriver-$CHROME_DRIVER_VERSION/chromedriver /usr/local/bin/chromedriver

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list \
  && apt-get update -qqy \
  && apt-get -qqy install google-chrome-stable \
  && rm /etc/apt/sources.list.d/google-chrome.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Add jenkins user
RUN useradd jenkins --shell /bin/bash --create-home \
  && usermod -a -G sudo jenkins \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'jenkins:nopassword' | chpasswd

# chown & apt-get clean
RUN mkdir /data && chown -R jenkins:jenkins /data && apt-get clean

USER jenkins