package("yoga")
    set_homepage("https://yogalayout.com")
    set_description("Yoga is a cross-platform layout engine which implements Flexbox.")
    set_license("MIT")
    set_urls("https://github.com/facebook/yoga/archive/v$(version).tar.gz")

    add_versions("3.0.3", "0ae44f7d30f8130cdf63e91293e11e34803afbfd12482fe4ef786435fc7fa8e7")
    add_versions("2.0.1", "4c80663b557027cdaa6a836cc087d735bb149b8ff27cbe8442fc5e09cec5ed92")
    add_versions("2.0.0", "29eaf05191dd857f76b6db97c77cce66db3c0067c88bd5e052909386ea66b8c5")
    on_install(function (package)
        os.cp(path.join(os.scriptdir(), "port", "xmake.lua"), "xmake.lua")
        local configs = {}
        import("package.tools.xmake").install(package, configs)
    end)

    on_test(function (package)
        assert(package:has_cfuncs("YGNodeNew", {includes = {"yoga/Yoga.h"}}))
    end)
