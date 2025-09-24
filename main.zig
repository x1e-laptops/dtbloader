extern "C" fn efi_main(handle: uefi.Handle, system_table: *uefi.tables.SystemTable) usize;

pub fn main() uefi.Status {
    return @enumFromInt(efi_main(uefi.handle, uefi.system_table));
}

const std = @import("std");
const uefi = std.os.uefi;
