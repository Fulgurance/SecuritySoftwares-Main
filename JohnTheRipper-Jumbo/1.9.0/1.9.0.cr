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
                                    --disable-mpi            \
                                    --enable-opencl         \
                                    --enable-pkg-config     \
                                    --enable-pcap",
                        path:       buildDirectoryPath,
                        relatedToMainBuild: false)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        exit 1

        moveFile("#{buildDirectoryPath}/run/john.conf","#{builtSoftwareDirectoryPath}/etc/john/")
        moveFile("#{buildDirectoryPath}/run/*.conf","#{builtSoftwareDirectoryPath}/usr/share/john/")

        moveFile("#{buildDirectoryPath}/run/john.bash_completion","#{builtSoftwareDirectoryPath}/usr/share/bash-completion/completions/john")
    end

end
