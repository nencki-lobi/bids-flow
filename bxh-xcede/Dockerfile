# Creates docker container that runs bxh-xcede-tools fmriqa algorithms
#
#

# Start with neurodebian image
FROM neurodebian:xenial
MAINTAINER LOBI <bkossowski@nencki.gov.pl>

# Add non-free sources
RUN echo deb http://neurodeb.pirsquared.org data main contrib non-free >> /etc/apt/sources.list.d/neurodebian.sources.list
RUN echo deb http://neurodeb.pirsquared.org xenial main contrib non-free >> /etc/apt/sources.list.d/neurodebian.sources.list

# Install packages
RUN apt-get update \
    && apt-get install -y \
    lsb-core \
    bsdtar \
    zip \
    unzip \
    gzip \
    curl \
    jq \
    python-pip \
    afni

# Download/install bhx-xcede tools
ENV VERSION=bxh_xcede_tools-1.11.14-lsb30.x86_64
ENV LINK=https://www.nitrc.org/frs/download.php/10144/${VERSION}.tgz
RUN curl -#L  $LINK | bsdtar -xf- -C /opt/
ENV PATH=$PATH:/opt/${VERSION}/bin

# Download/Install webpage2html
ENV COMMIT=4dec20eba862335aaf1718d04b313bdc96e7dc8e
ENV URL=https://github.com/zTrix/webpage2html/archive/$COMMIT.zip
RUN curl -#L  $URL | bsdtar -xf- -C /opt/
WORKDIR /opt
RUN mv webpage2html-$COMMIT webpage2html
RUN pip install -r webpage2html/requirements.txt

RUN mkdir /usr/share/fonts/default && ln -s /usr/share/fonts/type1/gsfonts /usr/share/fonts/default/Type1

COPY run.sh /opt/run.sh

# Configure entrypoint
WORKDIR /opt
ENTRYPOINT ["/opt/run.sh"]
