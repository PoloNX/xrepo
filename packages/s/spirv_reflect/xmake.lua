local function getVersion(version) 
    return tostring(version):gsub('-release', '')
end

package("spirv_reflect")
    set_homepage("https://github.com/KhronosGroup/SPIRV-Reflect")
    set_description("SPIRV-Reflect is a lightweight library that provides a C/C++ reflection API for SPIR-V shader bytecode in Vulkan applications.")
    set_license("MIT")
    set_urls("https://github.com/KhronosGroup/SPIRV-Reflect/archive/refs/tags/sdk-$(version).tar.gz", {
        version = getVersion
    })

    add_versions("1.3.275-release.0", "0fe4430cd3a594772a88ba5ed96bb35992c0674cc2461a68d0d6e6586d9f10ba")
    add_versions("1.3.250-release.1", "aa0f202227d6e6f3f78c0e181ca57184c4491069588b284809c5ea99ef6f0440")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("spvReflectCreateShaderModule", {includes = {"spirv_reflect.h"}}))
    end)
