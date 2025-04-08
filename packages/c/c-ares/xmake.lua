package("c-ares")
    set_homepage("https://c-ares.org")
    set_description("A C library for asynchronous DNS requests")
    set_license("MIT")
    set_urls("https://github.com/c-ares/c-ares/releases/download/v$(version)/c-ares-$(version).tar.gz")

    --insert version
    add_versions("1.34.5", "7d935790e9af081c25c495fd13c2cfcda4792983418e96358ef6e7320ee06346")
    add_versions("1.34.4", "fa38dbed659ee4cc5a32df5e27deda575fa6852c79a72ba1af85de35a6ae222f")
    add_versions("1.34.3", "26e1f7771da23e42a18fdf1e58912a396629e53a2ac71b130af93bbcfb90adbe")
    on_load(function (package) 
        if package:is_plat("windows", "mingw") and package:config("shared") ~= true then
            package:add("defines", "CARES_STATICLIB")
        end
    end)
    on_install(function (package)
        local transforme_configfile = function (input, output) 
            output = output or input
            local lines = io.readfile(input):gsub("@([%w_]+)@", "${%1}"):split("\n")
            local out = io.open(output, 'wb')
            for _, line in ipairs(lines) do
                if line:startswith("#cmakedefine") then
                    local name = line:split("%s+")[2]
                    line = "${define "..name.."}"
                end
                out:write(line)
                out:write("\n")
            end
            out:close()
        end
        transforme_configfile("include/ares_build.h.cmake", "cmake/ares_build.h.in")
        transforme_configfile("src/lib/ares_config.h.cmake", "cmake/ares_config.h.in")
        os.cp(path.join(os.scriptdir(), "port/*.lua"), "./")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("ares_library_initialized", {includes = {"ares.h"}}))
    end)
