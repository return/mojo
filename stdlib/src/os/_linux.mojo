# ===----------------------------------------------------------------------=== #
#
# This file is Modular Inc proprietary.
#
# ===----------------------------------------------------------------------=== #

from time.time import _CTimeSpec
from utils.index import StaticIntTuple
from sys.ffi import _get_dylib_function, DLHandle


alias dev_t = Int64
alias mode_t = Int32
alias nlink_t = Int64

alias uid_t = Int32
alias gid_t = Int32
alias off_t = Int64
alias blkcnt_t = Int64
alias blksize_t = Int64


@value
@register_passable("trivial")
struct _c_stat(Stringable):
    var st_dev: dev_t  #  ID of device containing file
    var st_ino: Int64  # File serial number
    var st_nlink: nlink_t  # Number of hard links
    var st_mode: mode_t  # Mode of file
    var st_uid: uid_t  # User ID of the file
    var st_gid: gid_t  # Group ID of the file
    var __pad0: Int32  # Padding
    var st_rdev: dev_t  # Device ID
    var st_size: off_t  # file size, in bytes
    var st_blksize: blksize_t  # optimal blocksize for I/O
    var st_blocks: blkcnt_t  #  blocks allocated for file
    var st_atimespec: _CTimeSpec  # time of last access
    var st_mtimespec: _CTimeSpec  # time of last data modification
    var st_ctimespec: _CTimeSpec  # time of last status change
    var st_birthtimespec: _CTimeSpec  # time of file creation(birth)
    var unused: StaticTuple[3, Int64]  # RESERVED: DO NOT USE!

    fn __init__() -> Self:
        return Self {
            st_dev: 0,
            st_mode: 0,
            st_nlink: 0,
            st_ino: 0,
            st_uid: 0,
            st_gid: 0,
            __pad0: 0,
            st_rdev: 0,
            st_size: 0,
            st_blksize: 0,
            st_blocks: 0,
            st_atimespec: _CTimeSpec(),
            st_mtimespec: _CTimeSpec(),
            st_ctimespec: _CTimeSpec(),
            st_birthtimespec: _CTimeSpec(),
            unused: StaticTuple[3, Int64](0, 0, 0),
        }

    fn __str__(self) -> String:
        var res = String("{\n")
        res += "st_dev: " + str(self.st_dev) + ",\n"
        res += "st_mode: " + str(self.st_mode) + ",\n"
        res += "st_nlink: " + str(self.st_nlink) + ",\n"
        res += "st_ino: " + str(self.st_ino) + ",\n"
        res += "st_uid: " + str(self.st_uid) + ",\n"
        res += "st_gid: " + str(self.st_gid) + ",\n"
        res += "st_rdev: " + str(self.st_rdev) + ",\n"
        res += "st_size: " + str(self.st_size) + ",\n"
        res += "st_blksize: " + str(self.st_blksize) + ",\n"
        res += "st_blocks: " + str(self.st_blocks) + ",\n"
        res += "st_atimespec: " + str(self.st_atimespec) + ",\n"
        res += "st_mtimespec: " + str(self.st_mtimespec) + ",\n"
        res += "st_ctimespec: " + str(self.st_ctimespec) + ",\n"
        res += "st_birthtimespec: " + str(self.st_birthtimespec) + "\n"
        return res + "}"


@always_inline
fn _stat(path: String) raises -> _c_stat:
    var stat = _c_stat()
    let err = external_call["__xstat", Int32](
        Int32(0), path._as_ptr(), Pointer.address_of(stat)
    )
    if err == -1:
        raise "unable to stat '" + path + "'"
    return stat


@always_inline
fn _lstat(path: String) raises -> _c_stat:
    var stat = _c_stat()
    let err = external_call["__lxstat", Int32](
        Int32(0), path._as_ptr(), Pointer.address_of(stat)
    )
    if err == -1:
        raise "unable to lstat '" + path + "'"
    return stat
