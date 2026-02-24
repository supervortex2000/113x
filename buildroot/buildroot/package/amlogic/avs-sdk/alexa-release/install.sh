#!/bin/sh

source ./setup.sh

rm ${HOME_PATH}/avs-out/lib/libnghttp2.so
rm ${HOME_PATH}/avs-out/lib/libnghttp2.so.14

ln -s ${HOME_PATH}/avs-out/lib/libnghttp2.so.14.14.0 ${HOME_PATH}/avs-out/lib/libnghttp2.so.14

ln -s ${HOME_PATH}/avs-out/lib/libnghttp2.so.14.14.0 ${HOME_PATH}/avs-out/lib/libnghttp2.so

rm ${HOME_PATH}/avs-out/lib/libopus.so
rm ${HOME_PATH}/avs-out/lib/libopus.so.0
rm ${HOME_PATH}/avs-out/lib/libcrypto.so.1.1

ln -s ${HOME_PATH}/avs-out/lib/libopus.so.0.8.0 ${HOME_PATH}/avs-out/lib/libopus.so

ln -s ${HOME_PATH}/avs-out/lib/libopus.so.0.8.0 ${HOME_PATH}/avs-out/lib/libopus.so.0

ln -s ${HOME_PATH}/avs-out/lib/libcrypto.so ${HOME_PATH}/avs-out/lib/libcrypto.so.1.1

rm ${HOME_PATH}/avs-out/lib/libmbedcrypto.so
rm ${HOME_PATH}/avs-out/lib/libmbedcrypto.so.4

ln -s ${HOME_PATH}/avs-out/lib/libmbedcrypto.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedcrypto.so
ln -s ${HOME_PATH}/avs-out/lib/libmbedcrypto.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedcrypto.so.4

rm ${HOME_PATH}/avs-out/lib/libmbedtls.so
rm ${HOME_PATH}/avs-out/lib/libmbedtls.so.13

ln -s ${HOME_PATH}/avs-out/lib/libmbedtls.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedtls.so
ln -s ${HOME_PATH}/avs-out/lib/libmbedtls.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedtls.so.13

rm ${HOME_PATH}/avs-out/lib/libmbedx509.so
rm ${HOME_PATH}/avs-out/lib/libmbedx509.so.1

ln -s ${HOME_PATH}/avs-out/lib/libmbedx509.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedx509.so
ln -s ${HOME_PATH}/avs-out/lib/libmbedx509.so.2.21.0 ${HOME_PATH}/avs-out/lib/libmbedx509.so.1

rm ${HOME_PATH}/usr/lib/libsndfile.so.1
rm ${HOME_PATH}/usr/lib/libxml2.so.2
rm ${HOME_PATH}/usr/lib/libfdk-aac.so.1
rm ${HOME_PATH}/usr/lib/libiw.so
rm ${HOME_PATH}/usr/lib/libatomic.so
rm ${HOME_PATH}/usr/lib/libatomic.so.1

ln -s ${HOME_PATH}/usr/lib/libsndfile.so.1.0.28 ${HOME_PATH}/usr/lib/libsndfile.so.1
ln -s ${HOME_PATH}/usr/lib/libxml2.so.2.9.3 ${HOME_PATH}/usr/lib/libxml2.so.2
ln -s ${HOME_PATH}/usr/lib/libfdk-aac.so.1.0.1 ${HOME_PATH}/usr/lib/libfdk-aac.so.1

ln -s ${HOME_PATH}/usr/lib/libiw.so.29 ${HOME_PATH}/usr/lib/libiw.so
ln -s ${HOME_PATH}/usr/lib/libatomic.so.1.2.0 ${HOME_PATH}/usr/lib/libatomic.so
ln -s ${HOME_PATH}/usr/lib/libatomic.so.1.2.0 ${HOME_PATH}/usr/lib/libatomic.so.1


#cd /usr/share/alexa-release/output-arm/lib
#chmod 777 ./do_ln.sh
#./do_ln.sh
