#! /bin/sh

set -e

aclocal
autoconf
autoheader

# FIXME: automake doesn't like that there's no Makefile.am
automake -a -c -f || true

echo timestamp > stamp-h.in

python util/import_gcry.py lib/libgcrypt/ .

python util/import_unicode.py unicode/UnicodeData.txt unicode/BidiMirroring.txt unicode/ArabicShaping.txt unidata.c

for rmk in conf/*.rmk ${GRUB_CONTRIB}/*/conf/*.rmk; do
  if test -e $rmk ; then
    ruby genmk.rb < $rmk > `echo $rmk | sed 's/\.rmk$/.mk/'`
  fi
done

sh gendistlist.sh > DISTLIST

rm -f config.sub config.guess
ln -s /usr/share/misc/config.sub .
ln -s /usr/share/misc/config.guess .

exit 0
