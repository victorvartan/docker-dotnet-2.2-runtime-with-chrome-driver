# docker image build -t victorvartan/dotnet-2.2-runtime-with-chrome-driver:latest .

FROM microsoft/dotnet:2.2-runtime

# Install utils
RUN apt-get update && apt-get install -y \
apt-utils \
apt-transport-https \
ca-certificates \
curl \
unzip \
gnupg \
hicolor-icon-theme \
libcanberra-gtk* \
libgl1-mesa-dri \
libgl1-mesa-glx \
libpango1.0-0 \
libpulse0 \
libv4l-0 \
fonts-symbola \
--no-install-recommends

# Install Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
  && apt-get update -qqy \
  && apt-get -qqy install \
    google-chrome-stable \
	--no-install-recommends \
  && rm /etc/apt/sources.list.d/google.list \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Download ChromeDriver
RUN mkdir /opt/chromedriver \
&& curl -sSL "https://chromedriver.storage.googleapis.com/2.45/chromedriver_linux64.zip" -o /tmp/chromedriver_linux64.zip \
&& unzip -o /tmp/chromedriver_linux64.zip -d /opt/chromedriver/

# Cleanup
RUN rm -rf /tmp/*.* \
&& apt-get purge -y --auto-remove curl unzip

# Add Chrome user
RUN groupadd -r chrome && useradd -r -g chrome -G audio,video chrome \
&& mkdir -p /app/downloads && chown -R chrome:chrome /app