Cam = {
    inAnimationCam = false,
    cams = {},

    RemoveAll = function()
        for k, v in pairs(Cam.cams) do
            Cam.delete(k)
        end
        DestroyAllCams(0)
        DestroyAllCams(1)
    end,

    Get = function(name)
        return Cam.cams[name]
    end,

    isActive = function(name)
        if Cam.cams[name] ~= nil then
            return IsCamActive(Cam.cams[name])
        else

        end
    end,

    create = function(name)
        if Cam.cams[name] ~= nil then
            Cam.delete(name)

        end
        local c = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
        Cam.cams[name] = c
    end,

    delete = function(name)
        if Cam.cams[name] ~= nil then
            RenderScriptCams(0, 0, 0, 0, 1)
            SetCamActive(Cam.cams[name], false)
            DestroyCam(Cam.cams[name])
            ClearFocus()
            Cam.cams[name] = nil
        else

        end
    end,

    setActive = function(name, bool)
        if Cam.cams[name] ~= nil then
            SetCamActive(Cam.cams[name], bool)
        else

        end
    end,

    setPos = function(name, pos)
        if Cam.cams[name] ~= nil then
            SetFocusPosAndVel(pos.xyz, 0.0, 0.0, 0.0)
            SetCamCoord(Cam.cams[name], pos.xyz)
        else

        end
    end,

    setFov = function(name, fov)
        if Cam.cams[name] ~= nil then
            SetCamFov(Cam.cams[name], fov)
        else

        end
    end,

    shake = function(name, type, amplitude)
        if Cam.cams[name] ~= nil then
            ShakeCam(Cam.cams[name], type, amplitude)
        else

        end

    end,
    lookAtCoords = function(name, pos)
        if Cam.cams[name] ~= nil then
            PointCamAtCoord(Cam.cams[name], pos.xyz)
        else

        end
    end,

    lookAtEntity = function(name, entity, offsets)
        if Cam.cams[name] ~= nil then
            PointCamAtEntity(Cam.cams[name], entity, offsets[1], offsets[2], offsets[3])
        else

        end
    end,

    attachToEntity = function(name, entity, xOffset, yOffset, zOffset, isRelative)
        if Cam.cams[name] ~= nil then
            AttachCamToEntity(Cam.cams[name], entity, xOffset, yOffset, zOffset, isRelative)
        else

        end
    end,

    attachToEntityBone = function(name, ped, boneIndex, x, y, z, heading)
        if Cam.cams[name] ~= nil then
            AttachCamToPedBone(Cam.cams[name], ped, boneIndex, x, y, z, heading)
        else

        end
    end,

    attachToVehicleBone = function(name, vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX, offY, offZ,
                                   fixedDirection)
        if Cam.cams[name] ~= nil then
            AttachCamToVehicleBone(Cam.cams[name], vehicle, boneIndex, relativeRotation, rotX, rotY, rotZ, offX,
                offY, offZ, fixedDirection)
        else

        end
    end,

    render = function(name, render, animation, time)
        if Cam.cams[name] ~= nil then
            SetCamActive(Cam.cams[name], true)
            RenderScriptCams(render, animation, time, 1, 1)
            if not render then
                ClearFocus()
            end
        else

        end
    end,

    switchToCam = function(name, oldCam, time)
        if Cam.cams[name] ~= nil then
            if Cam.cams[oldCam] ~= nil then
                SetCamActive(Cam.cams[name], true)
                SetCamActive(Cam.cams[oldCam], true)
                SetCamActiveWithInterp(Cam.cams[name], Cam.cams[oldCam], time, 1, 1)
            else

            end
        else

        end
    end,

    animateToCoords = function(name, position, rotation, fov, speed, rotationOrder)
        if Cam.cams[name] ~= nil then
            SetCamActive(Cam.cams[name], true)

            SetCamParams(Cam.cams[name], position.xyz, rotation.xyz, fov, speed, 1, 3, rotationOrder)
        else

        end
    end,

    rotation = function(name, rotX, rotY, rotZ)
        if Cam.cams[name] ~= nil then
            SetCamRot(Cam.cams[name], rotX, rotY, rotZ, 2)
        else

        end
    end,

    dof_settings = {
        dofStrength = 0.0,
        dofNear = 0.0,
        dofFar = 0.0,
    },

    dof = function(name, Strength, near, Far, smoothTransition)
        if smoothTransition == nil then
            smoothTransition = true
        end
        if not smoothTransition then
            Cam.dof_settings.dofStrength = Strength
            Cam.dof_settings.dofNear = near
            Cam.dof_settings.dofFar = Far
        else
            Cam.dof_settings.dofStrength = Cam.dof_settings.dofStrength + ((Strength - Cam.dof_settings.dofStrength) * (0.005 *  Utils.TimeFrame))
            Cam.dof_settings.dofNear = Cam.dof_settings.dofNear + ((near - Cam.dof_settings.dofNear) * (0.005 *  Utils.TimeFrame))
            Cam.dof_settings.dofFar = Cam.dof_settings.dofFar + ((Far - Cam.dof_settings.dofFar) * (0.005 * Utils.TimeFrame))
        end
        local cams = Cam.Get(name)
        SetUseHiDof()
        SetCamDofStrength(cams, Cam.dof_settings.dofStrength)
        SetCamNearDof(cams, Cam.dof_settings.dofNear)
        SetCamFarDof(cams, Cam.dof_settings.dofFar)
        SetCamUseShallowDofMode(cams, true)
    end,
}
