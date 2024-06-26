local function getVersion(version)
    local versions ={
        ["2023.08.05-alpha"] = "archive/47d92ff86298fc96b3b84d93d0ee8c8533d3a2d2.tar.gz",
        ["2023.10.07-alpha"] = "archive/d98c8b92c25070f13d0491f5fade1d9d2ca885ad.tar.gz",
        ["2023.10.27-alpha"] = "archive/9e0f1b4e550998127c8f884ff7cc63838cf61860.tar.gz",
        ["2024.02.27-alpha"] = "archive/d98010b3c8ab91d3963aa23a4696f3f2fa517e4c.tar.gz",
        ["2024.02.29-alpha"] = "archive/ae501fb24a5711853401a88b06e264166aaf0ebe.tar.gz",
        ["2024.04.13-alpha"] = "archive/c2bb83f0b35e09d97a354b5f4cf4c3df783c4193.tar.gz",
    }
    return versions[tostring(version)]
end

package("sokol")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/floooh/sokol")
    set_description("Simple STB-style cross-platform libraries for C and C++, written in C.")
    set_license("zlib")

    set_urls("https://github.com/floooh/sokol/$(version)", {
        version = getVersion
    })
    add_versions("2024.04.13-alpha", "ad79d55052df7c57e98ee504cd67e7e1421f21f93ef904f43da3b30faf08a12a")
    add_versions("2024.02.29-alpha", "2906f047bf6da3ce50d2a6ae850eb024a4bfc26c130c3f08d4d3164244a971b3")
    add_versions("2024.02.27-alpha", "9b3752c8c85de55a4c2c5ab999f7926a451e91814af5573dbcb7bfcf5aa2476a")
    add_versions("2023.10.27-alpha", "c1f992e201d223b622551331961b3fc8a52f6f652d9cb99832b0aabe701ff7c1")
    add_versions("2023.10.07-alpha", "8feafbe69626fa33d071ebeef158431fab4831c77e60fff91a6f659ba34d0353")
    add_versions("2023.08.05-alpha", "bfad73555e07e1f7a0b257f612ac62cb1f858169c39e1df1fd134431cdb07c64")

    on_install(function (package)
        os.cp("*.h", package:installdir("include"))
        os.cp("util/*.h", package:installdir("include", "util"))
    end)

    on_test(function (package)
        assert(package:has_cfuncs("sargs_setup", {includes = "sokol_args.h", defines = "SOKOL_IMPL"}))
    end)
