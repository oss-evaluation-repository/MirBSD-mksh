#!/bin/sh
# $MirBSD: BuildGNU.sh,v 1.5 2004/03/22 19:03:52 tg Exp $
#-
# Copyright (c) 2004
#	Thorsten "mirabile" Glaser <x86@ePost.de>
#
# Subject to these terms, everybody who obtained a copy of this work
# is hereby permitted to deal in the work without restriction inclu-
# ding without limitation the rights to use, distribute, sell, modi-
# fy, publically perform, give away, merge or sublicence it provided
# this notice is kept and the authors and contributors are given due
# credit in derivates or accompanying documents.
#
# This work is provided by its developers (authors and contributors)
# "as is" and without any warranties whatsoever, express or implied,
# to the maximum extent permitted by applicable law; in no event may
# developers be held liable for damage caused, directly or indirect-
# ly, but not by a developer's malice intent, even if advised of the
# possibility of such damage.
#-
# Build the mirbsdksh on GNU operating systems

CC="${CC:-gcc}"
CPPFLAGS="$CPPFLAGS -DHAVE_CONFIG_H -I."
CFLAGS="-O2 -fomit-frame-pointer -fno-strict-aliasing -static $CFLAGS"

if [ -e strlcpy.c -a -e strlcat.c ]; then
	echo "Configuring..."
	/bin/sh ./configure
	echo "Generating prerequisites..."
	/bin/sh ./siglist.sh "gcc -E $CPPFLAGS" <siglist.in >siglist.out
	/bin/sh ./emacs-gen.sh emacs.c >emacs.out
	echo "Building..."
	$CC $CFLAGS $CPPFLAGS -DKSH -o ksh *.c
	echo "Finalizing..."
	tbl <ksh.1tbl | nroff -mandoc -Tascii >ksh.cat1
	strip -R .note -R .comment -R .rel.dyn -R .sbss \
	    --strip-unneeded --strip-all ksh
	size ksh
	echo "done."
else
	echo "Copy strlcpy.c and strlcat.c here first, and"
	echo "optionally kill Ulrich Drepper & co. for not"
	echo "including it into your broken libc imitation"
fi
