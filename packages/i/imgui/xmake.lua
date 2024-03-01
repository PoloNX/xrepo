function getVersion(version)
    local versions = {
        ["2024.02.29-alpha"] = "archive/04f40014a62898d325cbc987c9f56073b2d17e73.tar.gz",
    }
    local url = versions[tostring(version)]
    return url ~= nil and url or "archive/refs/tags/v"..tostring(version)..".tar.gz"
end

package("imgui")
    set_homepage("https://github.com/ocornut/imgui")
    set_description("Dear ImGui: Bloat-free Graphical User interface for C++ with minimal dependencies")
    set_license("MIT")
    set_urls("https://github.com/ocornut/imgui/$(version)", {
        version=getVersion
    })
    add_versions("2024.02.29-alpha", "a42ba44824b29de233c8554e03eb65a6d0850e05354ccb6d16e1d91c1dc576aa")
    add_versions("1.90.4", "5d9dc738af74efa357f2a9fc39fe4a28d29ef1dfc725dd2977ccf3f3194e996e")
    add_versions("1.90", "170986e6a4b83d165bfc1d33c2c5a5bc2d67e5b97176287485c51a2299249296")

    add_configs("backend", {description = "Select backend", default = "", type = "string"})
    add_configs("freetype", {description = "Use freetype", default = false, type = "boolean"})

    add_includedirs("include")
    add_includedirs("include/imgui")

    on_load(function (package)
        if package:config("freetype") then
            package:add("deps", "freetype")
        end
    end)

    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        table.insert(configs, "--backend="..package:config("backend"))
        table.insert(configs, "--freetype="..(package:config("freetype") and "y" or "n"))
        import("package.tools.xmake").install(package, configs)
        local binary_to_compressed_c = package:installdir("bin").."/binary_to_compressed_c"
        if os.host() == "windows" or os.host() == "mingw" then
            binary_to_compressed_c = binary_to_compressed_c..".exe"
        end
        if os.exists(binary_to_compressed_c) then
            local fontDir = package:installdir("include/imgui/misc/fonts")
            if not os.exists(fontDir) then
                os.mkdir(fontDir)
            end
            for _, fontName in ipairs({
                "Cousine-Regular",
                "DroidSans",
                "Karla-Regular",
                "ProggyClean",
                "ProggyTiny",
                "Roboto-Medium",
            }) do
                local fontPath = "misc/fonts/"..fontName..".ttf"
                if os.exists(fontPath) then
                    fontName = fontName:gsub("-", "")
                    local outdata, errdata = os.iorunv(binary_to_compressed_c, {fontPath, fontName})
                    local f = io.open(path.join(fontDir, fontName..".h"), "wb")
                    f:write(outdata)
                    f:close()
                end
            end
        end
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
