class Target < ISM::PackagedSoftware

    def prepareInstallation
        if option("Openrc")
            prepareOpenrcServiceInstallation(   path:   "#{workDirectoryPath}/Nessusd-Init.d",
                                                name:   "nessusd")
        end

        super
    end

    def deploy
        super

        if autoDeployServices
            if option("Openrc")
                runRcUpdateCommand("add nessusd default")
            end
        end
    end

end
