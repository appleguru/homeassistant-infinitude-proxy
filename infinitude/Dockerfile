ARG BUILD_FROM
ARG UPSTREAM_TAG=latest
FROM nebulous/infinitude:${UPSTREAM_TAG}

COPY run.sh render-options.pl /opt/infinitude-addon/

ENTRYPOINT []
CMD [ "/opt/infinitude-addon/run.sh" ]

LABEL \
    io.hass.name="Infinitude" \
    io.hass.description="Local Carrier Infinity Touch thermostat proxy" \
    io.hass.type="addon"
