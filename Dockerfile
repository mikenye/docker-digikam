FROM jlesage/baseimage-gui:ubuntu-18.04

ENV LIBKSANE_RELEASE="tags/v18.12.3"

RUN set -x && \
    export DEBIAN_FRONTEND=noninteractive && \
    # Install prerequisites
    apt-get update && \
    apt-get install -y --no-install-recommends \
        adwaita-icon-theme \
        bison \
        breathe-icon-theme \
        breeze-icon-theme \
        cmake \
        deepin-icon-theme \
        doxygen \
        elementary-icon-theme \
        elementary-icon-theme \
        extra-cmake-modules \
        faba-icon-theme \
        faenza-icon-theme \
        flex \
        g++ \
        gcc \
        gettext \
        git \
        hicolor-icon-theme \
        human-icon-theme \
        humanity-icon-theme \
        kgraphviewer-dev \
        libavcodec-dev \
        libavcodec57 \
        libavdevice-dev \
        libavfilter-dev \
        libavfilter6 \
        libavutil-dev \
        libc-dev \
        libeigen3-dev \
        libexpat1-dev \
        libgphoto2-6 \
        libgphoto2-dev \
        libjpeg-dev \
        libkf5akonadicontact-dev \
        libkf5akonadicontact5abi1 \
        libkf5configcore5 \
        libkf5contacts-dev \
        libkf5coreaddons5 \
        libkf5filemetadata-dev \
        libkf5filemetadata3 \
        libkf5i18n5 \
        libkf5kio-dev \
        libkf5kontactinterface-dev \
        libkf5notifications-dev \
        libkf5notifications5 \
        libkf5notifyconfig-dev \
        libkf5notifyconfig5 \
        libkf5sane-dev \
        libkf5solid-dev \
        libkf5threadweaver-dev \
        libkf5xmlgui-dev \
        liblcms2-dev \
        liblensfun-dev \
        liblensfun1 \
        liblqr-1-0-dev \
        libmagick++-6.q16-7 \
        libmagick++-dev \
        libmarble-dev \
        libmarblewidget-qt5-28 \
        libopenexr22 \
        libpng++-dev \
        libpostproc-dev \
        libqt5concurrent5 \
        libqt5opengl5-dev \
        libqt5sql5 \
        libqt5webenginewidgets5 \
        libqt5widgets5 \
        libqt5x11extras5-dev \
        libqt5xmlpatterns5-dev \
        libqtav-dev \
        libqtav1 \
        libqtavwidgets1 \
        libsane-dev \
        libswscale-dev \
        libtiff-dev \
        libx265-dev \
        libxslt1-dev \
        make \
        mariadb-server \
        oxygen-icon-theme \
        qt5-default \
        qttools5-dev-tools \
        qtwebengine5-dev \
        sqlite3 \
        ubuntu-mono \
        x265 \
        xubuntu-icon-theme \
        && \
    # Clone & Build exiv2
    git clone https://github.com/Exiv2/exiv2.git /src/exiv2 && \
    mkdir -p /src/exiv2/build && \
    cd /src/exiv2/build || exit 1 && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . && \
    make tests && \
    make install && \
    # Clone & Build jasper
    git clone https://github.com/mdadams/jasper.git /src/jasper && \
    mkdir -p /src/jasper_build && \
    cmake -G "Unix Makefiles" -H/src/jasper -B/src/jasper_build -DCMAKE_INSTALL_PREFIX="/usr/local" && \
    cd /src/jasper_build || exit 1 && \
    make clean all && \
    make install && \
    # Clone & Build libkvkontakte
    git clone https://github.com/KDE/libkvkontakte.git /src/libkvkontakte && \
    mkdir /src/libkvkontakte/build && \
    cd /src/libkvkontakte/build || exit 1 && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . && \
    make install && \
    # Clone & Build libksane
    git clone https://github.com/KDE/libksane.git /src/libksane && \
    cd /src/libksane || exit 1 && \
    git checkout "${LIBKSANE_RELEASE}" && \
    mkdir /src/libksane/build && \
    cd /src/libksane/build || exit 1 && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    cmake --build . && \
    make install && \
    # Clone & Build OpenCV
    git clone https://github.com/opencv/opencv.git /src/opencv && \
    mkdir -p /src/opencv/build && \
    cd /src/opencv/build || exit 1 && \
    cmake -D CMAKE_BUILD_TYPE=Release .. && \
    make -j 4 && \
    make install && \
    # Clone digikam repo
    git clone https://invent.kde.org/kde/digikam.git /src/digikam && \
    cd /src/digikam || exit 1 && \
    # Get latest digikam version tag and checkout
    DIGIKAM_RELEASE=$(git tag --list --sort -creatordate | head -1) && \
    git checkout tags/"${DIGIKAM_RELEASE}" && \
    echo "digikam ${DIGIKAM_RELEASE}" >> /VERSIONS && \
    # Build digikam (finally!)
    ./bootstrap.linux && \
    cd /src/digikam/build && \
    make doc && \
    make -j 4 && \
    make install && \
    # Clean up
    apt-get remove -y \
        bison \
        cmake \
        doxygen \
        extra-cmake-modules \
        flex \
        g++ \
        gcc \
        git \
        kgraphviewer-dev \
        libavcodec-dev \
        libavdevice-dev \
        libavfilter-dev \
        libavutil-dev \
        libc-dev \
        libeigen3-dev \
        libexpat1-dev \
        libgphoto2-dev \
        libjpeg-dev \
        libkf5akonadicontact-dev \
        libkf5contacts-dev \
        libkf5filemetadata-dev \
        libkf5kio-dev \
        libkf5kontactinterface-dev \
        libkf5notifications-dev \
        libkf5notifyconfig-dev \
        libkf5sane-dev \
        libkf5solid-dev \
        libkf5threadweaver-dev \
        libkf5xmlgui-dev \
        liblcms2-dev \
        liblensfun-dev \
        liblqr-1-0-dev \
        libmagick++-dev \
        libmarble-dev \
        libpng++-dev \
        libpostproc-dev \
        libqt5opengl5-dev \
        libqt5x11extras5-dev \
        libqt5xmlpatterns5-dev \
        libqtav-dev \
        libsane-dev \
        libswscale-dev \
        libtiff-dev \
        libx265-dev \
        libxslt1-dev \
        make \
        qt5-default \
        qttools5-dev-tools \
        qtwebengine5-dev \
        && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    find /var/log -type f -exec truncate --size=0 {} \; && \
    rm -rf \
        /src \
        /tmp/* \
        /var/lib/dpkg/statoverride \
        /var/lib/apt/lists/* \
        && \
    echo "Finished."

COPY startapp.sh /startapp.sh
COPY default_digikamrc /default_digikamrc
COPY 99-digikam-init /etc/cont-init.d/99-digikam-init

ENV APP_NAME="digiKam"

VOLUME [ "/pictures", "/config" ]
