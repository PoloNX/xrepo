add_rules("mode.debug", "mode.release")

local sourceFiles = {
    "yoga/**.cpp"
}

target("yoga")
    set_kind("$(kind)")
    set_languages("c++20")
    add_includedirs(".")
    add_headerfiles("yoga/*.h", {prefixdir = "yoga"})
    add_headerfiles("yoga/event/*.h", {prefixdir = "yoga/event"})
    add_files("yoga/**.cpp")
    if is_plat("windows") then
        add_cxflags("/execution-charset:utf-8", "/source-charset:utf-8", {tools = {"clang_cl", "cl"}})
        add_cxxflags("/EHsc", {tools = {"clang_cl", "cl"}})
        if is_mode("release") then
            set_optimize("faster")
        end
    end
