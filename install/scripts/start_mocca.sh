#!/usr/bin/env bash
# start MOCCA

logger -p local0.info "MOCCA Webstart (lokale Bürgerkartenumgebung)"
cp -pr --no-clobber /opt/setup/mocca_settings/.java/ /home/liveuser/
cp -pr --no-clobber /opt/setup/mocca_settings/.mocca /home/liveuser/
cp -pr --no-clobber /opt/setup/mocca_settings/.cache /home/liveuser/
cp -pr --no-clobber /opt/setup/mocca_settings/.config /home/liveuser/

javaws http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp

exit 0