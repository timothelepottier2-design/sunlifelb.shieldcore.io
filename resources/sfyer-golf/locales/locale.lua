Locales = {}

--== Gestion de la traduction

function parseText(identifier)
    if Locales[Config.Locale] then
        if Locales[Config.Locale][identifier] then
            return Locales[Config.Locale][identifier]
        else
            return "Locale " .. Config.Locale .. " not defined for " .. identifier
        end
    else
        return "Locale " .. Config.Locale .. " not found"
    end
end
