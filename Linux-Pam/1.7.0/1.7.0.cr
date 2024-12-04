class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                  \
                                    --reconfigure                           \
                                    #{@buildDirectoryNames["MainBuild"]}    \
                                    --prefix=/usr                           \
                                    --buildtype=release                     \
                                    -Ddocs=disabled                         \
                                    -Dsecuredir=/usr/lib/security           \
                                    -Dsconfigdir=/etc                       \
                                    -Dsystemdunitdir=no                     \
                                    ",
                        path:       mainWorkDirectoryPath)
    end

    def build
        super

        runNinjaCommand(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        runNinjaCommand(arguments:      "install",
                        path:           buildDirectoryPath,
                        environment:    {"DESTDIR" => "#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}"})

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")

        if !softwareIsInstalled("@SecuritySoftwares-Main:Linux-Pam")
            systemAccountData = <<-CODE
            account   required    pam_unix.so
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-account",systemAccountData)

            systemAuthData = <<-CODE
            auth      required    pam_unix.so
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-auth",systemAuthData)

            systemSessionData = <<-CODE
            session   required    pam_unix.so
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-session",systemSessionData)

            systemPasswordData = <<-CODE
            password  required    pam_unix.so       sha512 shadow try_first_pass
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/system-password",systemPasswordData)

            if option("Libpwquality")

                otherData = <<-CODE
                auth        required        pam_warn.so
                auth        required        pam_deny.so
                account     required        pam_warn.so
                account     required        pam_deny.so
                password    required        pam_warn.so
                password    required        pam_deny.so
                session     required        pam_warn.so
                session     required        pam_deny.so
                CODE
                fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/other",otherData)

            end
        end

        deleteFile("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/no")
    end

    def install
        super

        runChmodCommand("04755 /usr/sbin/unix_chkpwd")
    end

end
