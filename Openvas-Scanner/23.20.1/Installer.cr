class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runCmakeCommand(arguments:  "-DCMAKE_INSTALL_PREFIX=/usr                                \
                                    -DCMAKE_BUILD_TYPE=Release                                  \
                                    -DSBINDIR=/usr/bin                                          \
                                    -DLIBDIR=/usr/lib                                           \
                                    -DSYSCONFDIR=/etc                                           \
                                    -DLOCALSTATEDIR=/var                                        \
                                    -DOPENVAS_DATA_DIR=/var/lib/openvas                         \
                                    -DOPENVAS_FEED_LOCK_PATH=/var/lib/openvas/feed-update.lock  \
                                    -DOPENVAS_RUN_DIR=/run/ospd                                 \
                                    -DOPENVAS_NVT_DIR=/var/lib/openvas/plugins                  \
                                    -DBUILD_WITH_NETSNMP=True                                   \
                                    ..",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end

    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
