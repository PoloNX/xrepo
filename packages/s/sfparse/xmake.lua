local function getVersion(version)
    local versions ={
        ["2024.03.15-alpha"] = "archive/d15f85a6e64eabd2f57ab99771b06bf3b64eb6ab.tar.gz",
        ["2024.04.03-alpha"] = "archive/1a0b70cec753fade42648f93d533f5921794dd79.tar.gz",
    }
    return versions[tostring(version)]
end

package("sfparse")
    set_homepage("https://nghttp2.org/sfparse")
    set_description("Structured Field Values parser")
    set_license("MIT")
    set_urls("https://github.com/ngtcp2/sfparse/$(version)", {version = getVersion})

    add_versions("2024.04.03-alpha", "3eee90608f69da113c802532faf47db0496884d4530da79f897e1e70bf1ca988")
    add_versions("2024.03.15-alpha", "1f8ffc146be40904db10fb291267681a73fb16788e86137d71fa8f43f4f1a800")
    on_install(function (package)
        io.writefile("xmake.lua", [[
add_rules("mode.debug", "mode.release")
if is_plat("windows") then
    add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
    add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
end
target("sfparse")
    set_kind("$(kind)")
    add_files("sfparse.c")
    add_headerfiles("sfparse.h")
]])
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
