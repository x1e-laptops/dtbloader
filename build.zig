const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .aarch64,
        .os_tag = .uefi,
        .abi = .msvc,
    });
    const optimize = b.standardOptimizeOption(.{});

    const dtc_dep = b.dependency("dtc", .{});
    const sha1_dep = b.dependency("sha1", .{});
    const gnuefi_dep = b.dependency("gnu-efi", .{});
    const dtbloader_dep = b.dependency("dtbloader", .{});

    const lib_mod = b.createModule(.{
        .target = target,
        .optimize = optimize,
    });
    lib_mod.addIncludePath(dtbloader_dep.path("src/include"));
    lib_mod.addIncludePath(dtc_dep.path("libfdt"));
    lib_mod.addIncludePath(gnuefi_dep.path("inc"));

    const exe_mod = b.createModule(.{
        .root_source_file = b.path("main.zig"),
        .target = target,
        .optimize = optimize,
    });
    exe_mod.addIncludePath(sha1_dep.path("."));
    exe_mod.addIncludePath(dtbloader_dep.path("src/include"));

    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "dtbloader",
        .root_module = lib_mod,
    });
    lib.addCSourceFiles(.{
        .root = dtc_dep.path("libfdt"),
        .files = &libfdt_src,
        .flags = &.{
            "-fno-stack-protector",
            "-fshort-wchar",
            "-mno-red-zone",
        },
    });
    lib.addCSourceFiles(.{
        .root = gnuefi_dep.path("lib"),
        .files = &libefi_src,
        .flags = &.{
            "-fno-stack-protector",
            "-fshort-wchar",
            "-mno-red-zone",
        },
    });
    lib.installHeadersDirectory(
        dtc_dep.path("libfdt"),
        "",
        .{ .include_extensions = &.{".h"} },
    );
    lib.installHeadersDirectory(
        gnuefi_dep.path("inc"),
        "",
        .{ .include_extensions = &.{".h"} },
    );

    const exe = b.addExecutable(.{
        .name = "dtbloader",
        .root_module = exe_mod,
    });
    exe.subsystem = .EfiBootServiceDriver;
    exe.addCSourceFiles(.{
        .root = dtbloader_dep.path("src"),
        .files = &dtbloader_src,
        .flags = &.{
            "-fno-stack-protector",
            "-fshort-wchar",
            "-mno-red-zone",
        },
    });
    exe.addCSourceFiles(.{
        .root = dtbloader_dep.path("src/devices"),
        .files = &dtbloader_devices,
        .flags = &.{
            "-fno-stack-protector",
            "-fshort-wchar",
            "-mno-red-zone",
        },
    });
    exe.addCSourceFiles(.{
        .root = sha1_dep.path("."),
        .files = &.{"sha1.c"},
        .flags = &.{},
    });
    exe.linkLibrary(lib);
    b.installArtifact(exe);
}

const libfdt_src = [_][]const u8{
    "fdt.c",
    "fdt_addresses.c",
    "fdt_check.c",
    "fdt_empty_tree.c",
    "fdt_overlay.c",
    "fdt_ro.c",
    "fdt_rw.c",
    "fdt_strerror.c",
    "fdt_sw.c",
    "fdt_wip.c",
};

const libefi_src = [_][]const u8{
    "boxdraw.c",
    "smbios.c",
    "console.c",
    "crc.c",
    "data.c",
    "debug.c",
    "dpath.c",
    "entry.c",
    "error.c",
    "event.c",
    "exit.c",
    "guid.c",
    "hand.c",
    "hw.c",
    "init.c",
    "lock.c",
    "misc.c",
    "pause.c",
    "print.c",
    "sread.c",
    "str.c",
    "cmdline.c",
    "runtime/rtlock.c",
    "runtime/efirtlib.c",
    "runtime/rtstr.c",
    "runtime/vm.c",
    "runtime/rtdata.c",
    "aarch64/initplat.c",
    "aarch64/math.c",
};

const dtbloader_src = [_][]const u8{
    "main.c",
    "libc.c",
    "device.c",
    "util.c",
    "chid.c",
    "qcom.c",
};

const dtbloader_devices = [_][]const u8{
    "acer_aspire1.c",
    "acer_swift_14_ai.c",
    "acer_swift_go_14_ai.c",
    "asus_vivobook_s15.c",
    "asus_zenbook_a14_ux3407qa.c",
    "asus_zenbook_a14_ux3407ra.c",
    "dell_inspiron-14-plus-7441.c",
    "dell_latitude_5455.c",
    "dell_latitude_7455.c",
    "dell_xps_13_9345.c",
    "hp_elitebook_ultra_g1q.c",
    "hp_omnibook_x14.c",
    "hp_omnibook_x14_fe1xxx.c",
    "huawei_gaokun3.c",
    "lenovo_c630.c",
    "lenovo_flex5g.c",
    "lenovo_ideapad_5_2in1.c",
    "lenovo_ideapad_slim_5.c",
    "lenovo_miix630.c",
    "lenovo_slim7x.c",
    "lenovo_t14s_g6.c",
    "lenovo_tb16.c",
    "lenovo_x13s.c",
    "microsoft_surface7_2036.c",
    "microsoft_surface7_2037.c",
    "microsoft_surface9_5g.c",
    "microsoft_surface11.c",
    "microsoft_surface12in.c",
    "microsoft_wdk2023.c",
    "qcom_x1e_devkit.c",
};
