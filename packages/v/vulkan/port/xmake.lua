includes("check_cincludes.lua")
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

local sourceFiles = {}

target("vulkan")
    set_kind("$(kind)")

    check_cincludes("HAVE_UNISTD_H", "unistd.h")

    add_headerfiles("todo.h")
    for _, f in ipairs(sourceFiles) do
        add_files(f)
    end