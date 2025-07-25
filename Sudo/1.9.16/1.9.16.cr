class Target < ISM::Software

    def configure
        super

        configureSource(arguments:  "--prefix=/usr                                          \
                                    --libexecdir=/usr/lib                                   \
                                    --with-secure-path                                      \
                                    --with-all-insults                                      \
                                    --with-env-editor                                       \
                                    #{option("Linux-Pam") ? "--with-pam" : "--without-pam"} \
                                    --docdir=/usr/share/doc/#{versionName}                  \
                                    --with-passprompt=\"Password for %p: \"",
                        path:       buildDirectoryPath)
    end

    def build
        super

        makeSource(path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "DESTDIR=#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}  \
                                install_uid=#{systemId}                                         \
                                install_gid=#{systemId}                                         \
                                install",
                    path:       buildDirectoryPath)

        if option("Linux-Pam")
            makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d")

            sudoData = <<-CODE
            auth      include     system-auth
            account   include     system-account
            session   required    pam_env.so
            session   include     system-session
            CODE
            fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/pam.d/sudo",sudoData)
        end

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d")

        jdkData = <<-CODE
        Defaults env_keep += JAVA_HOME
        Defaults env_keep += CLASSPATH
        Defaults env_keep += _JAVA_OPTIONS
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d/jdk",jdkData)

        qtData = <<-CODE
        Defaults env_keep += QT5DIR
        Defaults env_keep += QT6DIR
        Defaults env_keep += QT_PLUGIN_PATH
        Defaults env_keep += QML2_IMPORT_PATH
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d/qt",qtData)

        makeDirectory("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d")

        kdeData = <<-CODE
        Defaults env_keep += KF5_PREFIX
        Defaults env_keep += KF6_PREFIX
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d/kde",kdeData)

        sudoConfigData = <<-CODE
        Defaults secure_path="/usr/sbin:/usr/bin"
        Defaults timestamp_timeout=0,pwfeedback
        %wheel ALL=(ALL) ALL
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d/00-sudo",sudoConfigData)

        #EXPERIMENTAL
        #Special rule for ism user
        # Basically, the idea is to allow the system user ism to run any privileged commands,
        # but it will be controled under the program. And the ism user should be always locked (no password set)
        ismConfigData = <<-CODE
        ism ALL=(ALL) NOPASSWD: ALL
        CODE
        fileWriteData("#{builtSoftwareDirectoryPath}#{Ism.settings.rootPath}etc/sudoers.d/ism",ismConfigData)
    end

    def deploy
        super

        runChownCommand("root:root /usr/bin/sudo")
        runChmodCommand("u+s /usr/bin/sudo")
    end

end
