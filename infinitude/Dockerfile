ARG BUILD_FROM
ARG UPSTREAM_REF=nebulous/infinitude:2026.9.0@sha256:df0b5b2f37a357e81679359edbc99600543b8e4bc88776e5767692e2d0d0c9e7
FROM ${UPSTREAM_REF}

COPY run.sh render-options.pl /opt/infinitude-app/

ENTRYPOINT []
CMD [ "/opt/infinitude-app/run.sh" ]

LABEL \
    io.hass.name="Infinitude" \
    io.hass.description="Local Carrier Infinity Touch thermostat proxy" \
    io.hass.type="app"
