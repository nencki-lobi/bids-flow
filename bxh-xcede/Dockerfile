# Creates docker container that runs bxh-xcede-tools fmriqa algorithms
#
#

FROM flywheel/bxh-xcede-tools-qa:1.0.2_1.11.14

COPY run.sh /opt/run.sh

# Configure entrypoint
WORKDIR /opt
ENTRYPOINT ["/opt/run.sh"]
