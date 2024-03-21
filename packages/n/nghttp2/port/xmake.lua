if xmake.version():gt("2.8.3") then
    includes("@builtin/check")
else
    includes("check_cincludes.lua")
end
add_rules("mode.debug", "mode.release")

if is_plat("windows") then
    add_cxflags("/utf-8")
end

function configvar_check_csymbol_exists(define_name, var_name, opt) 
    configvar_check_csnippets(define_name, 'void* a = (void*)'..var_name..';', opt)
end

set_configvar("PACKAGE_VERSION", "1.60.0")
set_configvar("PACKAGE_VERSION_NUM", 0x013c00)

-- configvar_check_sizeof("ssize_t", "ssize_t", {includes = {"sys/types.h"}})
configvar_check_cxxsnippets("HAVE_STD_MAP_EMPLACE", [[
#include <map>
int main() {
    std::map<int, int>().emplace(1, 2);
    return 0;
}]])
configvar_check_cxxsnippets("HAVE__EXIT", [[
#include <stdlib.h>
int main() {
    _Exit(0);
    return 0;
}]])
configvar_check_cfuncs("HAVE_ACCEPT4", "accept4", {includes = {"sys/types.h"}})
configvar_check_cfuncs("HAVE_CLOCK_GETTIME", "clock_gettime", {includes = {"time.h"}})
configvar_check_cfuncs("HAVE_MKOSTEMP", "mkostemp", {includes = {"stdlib.h"}})
configvar_check_cfuncs("HAVE_GETTICKCOUNT64", "GetTickCount64", {includes = {"windows.h"}})
configvar_check_cfuncs("HAVE_DECL_INITGROUPS", "initgroups", {includes = {"sys/types.h", "grp.h"}})
configvar_check_csymbol_exists("HAVE_DECL_CLOCK_MONOTONIC", "CLOCK_MONOTONIC", {includes = {"time.h"}})

configvar_check_cincludes("HAVE_ARPA_INET_H", "arpa/inet.h")
configvar_check_cincludes("HAVE_FCNTL_H", "fcntl.h")
configvar_check_cincludes("HAVE_INTTYPES_H", "inttypes.h")
configvar_check_cincludes("HAVE_LIMITS_H", "limits.h")
configvar_check_cincludes("HAVE_NETDB_H", "netdb.h")
configvar_check_cincludes("HAVE_NETINET_IN_H", "netinet/in.h")
configvar_check_cincludes("HAVE_NETINET_IP_H", "netinet/ip.h")
configvar_check_cincludes("HAVE_PWD_H", "pwd.h")
configvar_check_cincludes("HAVE_SYS_SOCKET_H", "sys/socket.h")
configvar_check_cincludes("HAVE_SYS_TIME_H", "sys/time.h")
configvar_check_cincludes("HAVE_SYSLOG_H", "syslog.h")
configvar_check_cincludes("HAVE_UNISTD_H", "unistd.h")
configvar_check_cincludes("HAVE_WINDOWS_H", "windows.h")
set_configvar("ENABLE_HTTP3", 1)

-- TODO
-- HAVE_JANSSON libjansson
-- HAVE_LIBXML2 libxml2
-- HAVE_MRUBY mruby
-- HAVE_NEVERBLEED neverbleed
-- HAVE_LIBEV libev
-- HAVE_LIBBROTLI brotli

if not is_plat("windows", "mingw") then
    set_configvar("HINT_NORETURN", "__attribute__((noreturn))")
else
    set_configvar("HINT_NORETURN", "")
end

target("nghttp2")
    set_kind("$(kind)")
    add_files("lib/*.c")
    add_includedirs("lib/includes", "$(buildir)")
    add_defines("HAVE_CONFIG_H")
    add_configfiles("lib/includes/nghttp2/nghttp2ver.h.in", "config.h.in")
    add_headerfiles("$(buildir)/*.h", {prefixdir = "nghttp2"})
    add_headerfiles("lib/includes/nghttp2/*.h", {prefixdir = "nghttp2"})