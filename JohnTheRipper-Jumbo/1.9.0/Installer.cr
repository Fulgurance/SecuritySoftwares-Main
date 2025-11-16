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
                                    --disable-opencl         \
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

        makeDirectory("#{builtSoftwareDirectoryPath}/etc/john/")
        makeDirectory("#{builtSoftwareDirectoryPath}/usr/share/john/")
        makeDirectory("#{builtSoftwareDirectoryPath}/usr/bin/")

        moveFile("#{mainWorkDirectoryPath}/run/*.conf","#{builtSoftwareDirectoryPath}/etc/john/")
        moveFile("#{mainWorkDirectoryPath}/run/*.chr","#{builtSoftwareDirectoryPath}/etc/john/")
        moveFile("#{mainWorkDirectoryPath}/run/password.lst","#{builtSoftwareDirectoryPath}/etc/john/")
        moveFile("#{mainWorkDirectoryPath}/run/rules","#{builtSoftwareDirectoryPath}/etc/john/")
        moveFile("#{mainWorkDirectoryPath}/run/ztex","#{builtSoftwareDirectoryPath}/etc/john/")

        moveFile("#{mainWorkDirectoryPath}/run/lib","#{builtSoftwareDirectoryPath}/usr/share/john/")
        moveFile("#{mainWorkDirectoryPath}/run/*.pl","#{builtSoftwareDirectoryPath}/usr/share/john/")
        moveFile("#{mainWorkDirectoryPath}/run/*.py","#{builtSoftwareDirectoryPath}/usr/share/john/")

        moveFile("#{mainWorkDirectoryPath}/run/john","#{builtSoftwareDirectoryPath}/usr/bin/john")
        moveFile("#{mainWorkDirectoryPath}/run/mailer","#{builtSoftwareDirectoryPath}/usr/bin/john-mailer")

        directoryContent("#{builtSoftwareDirectoryPath}/usr/share/john/*").each do |file|
            fileName = file.lchop(file[0..file.rindex("/")])

            if !File.symlink?(file) && !File.directory?(file)
                if (file[-3..-1] == ".py") || (file[-3..-1] == ".pl")

                    runChmodCommand("+x #{file}")
                    makeLink(   target: "../share/#{fileName}",
                        path:   "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}usr/bin/#{fileName}",
                        type:   :symbolicLink)

                end
            end
        end
    end

end
