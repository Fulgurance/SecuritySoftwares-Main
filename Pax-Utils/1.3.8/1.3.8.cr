class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def configure
        super

        runMesonCommand(arguments:  "setup                                                          \
                                    --reconfigure                                                   \
                                    #{@buildDirectoryNames["MainBuild"]}                            \
                                    --prefix=/usr                                                   \
                                    --buildtype=release                                             \
                                    -Dlddtree_implementation=python                                 \
                                    -Duse_libcap=#{option("Libcap") ? "enabled" : "disabled"}       \
                                    -Duse_seccomp=#{option("Libseccomp") ? "enabled" : "disabled"}  \
                                    -Dtests=false                                                   \
                                    -Duse_fuzzing=false",
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
    end

end
