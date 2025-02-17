class Target < ISM::Software

    def prepare
        @buildDirectory = true
        super
    end

    def build
        super

        makeSource( arguments: "PREFIX=/usr         \
                                SHARED=1            \
                                PRODUCTION=1        \
                                ENABLE_BRAIN=0      \
                                USE_SYSTEM_LZMA=1   \
                                USE_SYSTEM_OPENCL=1 \
                                USE_SYSTEM_UNRAR=1  \
                                USE_SYSTEM_ZLIB=1   \
                                USE_SYSTEM_XXHASH=1 \
                                VERSION_PURE=#{version}",
                    path: buildDirectoryPath)
    end
    
    def prepareInstallation
        super

        makeSource( arguments:  "PREFIX=/usr            \
                                SHARED=1                \
                                PRODUCTION=1            \
                                ENABLE_BRAIN=0          \
                                USE_SYSTEM_LZMA=1       \
                                USE_SYSTEM_OPENCL=1     \
                                USE_SYSTEM_UNRAR=1      \
                                USE_SYSTEM_ZLIB=1       \
                                USE_SYSTEM_XXHASH=1     \
                                VERSION_PURE=#{version} \
                                DESTDIR=#{builtSoftwareDirectoryPath}/#{Ism.settings.rootPath} install",
                    path:       buildDirectoryPath)
    end

end
