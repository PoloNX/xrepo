

local ALL_LIB = {
    "src/lib_base.c",
    "src/lib_math.c",
    "src/lib_bit.c",
    "src/lib_string.c",
    "src/lib_table.c",
    "src/lib_io.c",
    "src/lib_os.c",
    "src/lib_package.c",
    "src/lib_debug.c",
    "src/lib_jit.c",
    "src/lib_ffi.c",
    "src/lib_buffer.c"
}

local function generateVm(package)
    local arr = {
        table.join({
            "-m",
            "bcdef",
            "-o",
            "src/lj_bcdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "ffdef",
            "-o",
            "src/lj_ffdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "libdef",
            "-o",
            "src/lj_libdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "recdef",
            "-o",
            "src/lj_recdef.h"
        }, ALL_LIB),
        table.join({
            "-m",
            "vmdef",
            "-o",
            "src/jit/vmdef.lua"
        }, ALL_LIB),
        {
            "-m",
            "folddef",
            "-o",
            "src/lj_folddef.h",
            "src/lj_opt_fold.c"
        }
    }

    if package:is_plat("windows", "mingw") then
        table.insert(arr, {
            "-m",
            "peobj",
            "-o",
            "src/lj_vm.obj"
        })
    elseif package:is_plat("macosx", "iphoneos") then
        table.insert(arr, {
            "-m",
            "machasm",
            "-o",
            "src/lj_vm.S"
        })
    else
        table.insert(arr, {
            "-m",
            "elfasm",
            "-o",
            "src/lj_vm.asm"
        })
    end
    return arr
end

local function generateBuildvm(package) 
    local args = {
        "dynasm/dynasm.lua",
        "-D",
        "FFI",
    }
    if package:is_plat("windows", "mingw") then
        table.join2(args, {
            "-LN",
            "-D",
            "WIN",
            "-D",
            "JIT",
        })
    elseif package:is_plat("iphoneos") then
        table.join2(args, {
            "-D",
            "NO_UNWIND",
        })
    else
        table.join2(args, {
            "-D",
            "ENDIAN_LE",
            "-D",
            "FPU",
            "-D",
            "HFABI",
            "-D",
            "VER=80",
            "-D",
            "JIT",
        })
    end
    local dasc = nil
    if package:is_arch("x86") then
        dasc = "src/vm_x86.dasc"
    elseif package:is_arch("x86_64", "x64") then 
        table.join2(args, {"-D", "P64"})
        dasc = "src/vm_x64.dasc"
    elseif package:arch():startswith("arm64") then
        dasc = "src/vm_arm64.dasc"
        table.join2(args, {"-D", "DUALNUM", "-D", "ENDIAN_LE", "-D", "P64"})
    elseif package:arch():startswith("arm") then
        dasc = "src/vm_arm.dasc"
        table.join2(args, {"-D", "DUALNUM", "-D", "ENDIAN_LE"})
    end
    if package:is_plat("iphoneos") then
        table.join2(args, "-D", "IOS")
    end
    table.insert(args, "-o")
    table.insert(args, "src/host/buildvm_arch.h")
    table.insert(args, dasc)
    return args
end

local miniluaScript = [[
target("minilua")
    set_kind("binary")
    add_files("src/host/minilua.c")
    set_plat(os.host())
    set_arch(os.arch())
    %s
]]

local buildvmScript = [[
target("buildvm")
    set_kind("binary")
%s
    add_includedirs("dynasm")
    add_includedirs("src")
    add_files("src/host/buildvm*.c")
]]

local function getVersion(version)
    local versions ={
        ["2023.09.25"] = "archive/becf5cc65d966a8926466dd43407c48bfea0fa13.tar.gz",
    }
    return versions[tostring(version)]
end

package("luajit")
    set_homepage("https://luajit.org")
    set_description("LuaJIT is a Just-In-Time Compiler (JIT) for the Lua programming language. Lua is a powerful, dynamic and light-weight programming language. It may be embedded or used as a general-purpose, stand-alone language.")
    set_license("MIT")
    set_urls(
        "https://github.com/LuaJIT/LuaJIT/$(version)",
        {
            version = getVersion
        }
    )
    add_versions("2023.09.25", "6d7e8fc691d45fe837d05e2a03f3a41b0886a237544d30f74f1355ce2c8d9157")
    on_install("windows", "mingw", "macosx", "linux", "iphoneos", "android", function (package)
        local lua_target = nil
        local lua_os = nil
        local lua_arch32 = 0
        if os.host() == "windows" then
            lua_os = "LUAJIT_OS_WINDOWS"
        elseif os.host() == "macosx" then 
            lua_os = "LUAJIT_OS_OSX"
        elseif os.host() == "linux" or os.host() == "android" then 
            lua_os = "LUAJIT_OS_LINUX"
        end
        if package:is_arch("x86") then
            lua_target = "LUAJIT_ARCH_x86"
        elseif package:is_arch("x86_64", "x64") then
            lua_target = "LUAJIT_ARCH_x64"
        elseif package:arch():startswith("arm64") then
            lua_target = "LUAJIT_ARCH_arm64"
        elseif package:arch():startswith("arm") then
            lua_target = "LUAJIT_ARCH_arm"
            lua_arch32 = 1
        end

        local commonDefines = string.format([[
    add_defines("LUAJIT_OS=%s")
    add_defines("LUAJIT_TARGET=%s")
    add_defines("LJ_ARCH_HASFPU=1")
    add_defines("LJ_ABI_SOFTFP=0")
]], lua_os, lua_target)
        if package:is_plat("iphoneos") then
            commonDefines = commonDefines.."    add_defines(\"TARGET_OS_IPHONE=1\")\n"
            commonDefines = commonDefines.."    add_defines(\"LUAJIT_NO_UNWIND\")\n"
        else
            commonDefines = commonDefines.."    add_defines(\"TARGET_OS_IPHONE=0\")\n"
        end
        io.writefile("xmake.lua", string.format(miniluaScript, commonDefines, lua_arch32))
        local configs = {}
        import("package.tools.xmake").install(package, configs)
        local args = generateBuildvm(package)
        os.vrunv(
            package:installdir("bin").."/minilua",
            args
        )
        if os.exists("src/host/genversion.lua") and os.exists(".relver") then
            os.cp(".relver", "src/luajit_relver.txt")
            os.cd("src")
            os.vrunv(
                package:installdir("bin").."/minilua",
                {
                    "host/genversion.lua"
                }
            )
            os.cd("-")
        end
        local _buildvmScript = string.format(buildvmScript, commonDefines)
        io.writefile("xmake.lua", _buildvmScript)
        print(_buildvmScript)
        local buildvmConfig = {
            plat=os.host(),
            arch=os.arch()
        }
        if lua_arch32 == 1 then
            buildvmConfig["arch"] = (os.host() == "windows" or os.host() == "macosx") and "x86" or "i386"
        end
        import("package.tools.xmake").install(package, buildvmConfig)
        local arr = generateVm(package)
        for _, args in ipairs(arr) do
            os.vrunv(package:installdir("bin").."/buildvm", args)
        end
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        import("package.tools.xmake").install(package, configs)
        os.tryrm(package:installdir("bin").."/buildvm")
        os.tryrm(package:installdir("bin").."/minilua")
    end)

    -- on_test(function (package)
    --     assert(package:has_cfuncs("xxx", {includes = {"xx.h"}}))
    -- end)
