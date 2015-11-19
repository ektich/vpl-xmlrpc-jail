#!/bin/bash
#
# script to start vpl jail
#
VPL_OVERLAY=/usr/local/var/vpl-jail-system
VPL_JAILDIR=/jail

set -x
# variables above should be read from a configuration file.
# populating VPL_JAILDIR

# creating mount points
umask 0022
for  mp in dev/pts var/lib tmp home etc usr bin lib lib64 proc
 do 
   mkdir -p $VPL_JAILDIR/$mp
 done

chmod 777 $VPL_JAILDIR/tmp

mknod -m 666 $VPL_JAILDIR/dev/null c 1 3
mknod -m 666 $VPL_JAILDIR/dev/zero c 1 5
mknod -m 666 $VPL_JAILDIR/dev/full c 1 7
mknod -m 666 $VPL_JAILDIR/dev/random c 1 8
mknod -m 666 $VPL_JAILDIR/dev/urandom c 1 9
mknod -m 666 $VPL_JAILDIR/dev/tty c 5 0
mknod -m 666 $VPL_JAILDIR/dev/ptmx c 5 2
ln -s -s /proc/self/fd/0 $VPL_JAILDIR/dev/stdin
ln -s -s /proc/self/fd/1 $VPL_JAILDIR/dev/stdout
ln -s -s /proc/self/fd/2 $VPL_JAILDIR/dev/stderr

# layering things up
mount -t aufs -o br:$VPL_OVERLAY/etc=ro:/etc=ro none $VPL_JAILDIR/etc
mount --bind /dev/pts $VPL_JAILDIR/dev/pts
mount --bind /proc $VPL_JAILDIR/proc
mount --bind /usr $VPL_JAILDIR/usr
mount -o remount,ro,nosuid,bind /usr $VPL_JAILDIR/usr
mount --bind /bin $VPL_JAILDIR/bin
mount -o remount,ro,nosuid,bind /bin $VPL_JAILDIR/bin
mount --bind /lib $VPL_JAILDIR/lib
mount -o remount,ro,nosuid,bind /lib $VPL_JAILDIR/lib
mount --bind /lib64 $VPL_JAILDIR/lib64
mount -o remount,ro,nosuid,bind /lib64 $VPL_JAILDIR/lib64
mount --bind /var/lib $VPL_JAILDIR/var/lib
mount -o remount,ro,nosuid,bind /var/lib $VPL_JAILDIR/var/lib

