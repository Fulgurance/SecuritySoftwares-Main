class Target < ISM::Software

    def prepare
        @buildDirectory = true
        @buildDirectoryNames["MainBuild"] = "src"
        super

        runAutoreconfCommand(   arguments: "-fiv",
                                path: buildDirectoryPath)
    end

    def configure
        super

        configureSource(arguments:  "--prefix=/usr          \
                                    --with-systemwide       \
                                    --disable-native-tests  \
                                    --enable-openmp         \
                                    --enable-mpi            \
                                    --enable-opencl         \
                                    --enable-pkg-config     \
                                    --enable-pcap",
                        path:       buildDirectoryPath,
                        environment:    {   "CFLAGS" => "${CFLAGS} -DCPU_FALLBACK"})
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
