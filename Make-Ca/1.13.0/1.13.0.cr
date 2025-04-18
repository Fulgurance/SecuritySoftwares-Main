class Target < ISM::Software
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}/etc/ssl/local")
    end

    def install
        super

        softwareIsInstalled("@SecuritySoftwares-Main:Make-Ca") ? runMakeCaCommand("-r") : runMakeCaCommand("-g")
    end

end
