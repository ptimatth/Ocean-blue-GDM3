#!/bin/sh
gst=/usr/share/gnome-shell/gnome-shell-theme.gresource
workdir=$PWD

for r in `gresource list $gst`; do
	r=${r#\/org\/gnome\/shell/}
	if [ ! -d $workdir/${r%/*} ]; then
	  mkdir -p $workdir/${r%/*}
	fi
done

for r in `gresource list $gst`; do
        gresource extract $gst $r >$workdir/${r#\/org\/gnome\/shell/}
done


printf "Would you want spacex background (y/N)?  -> "

read withSpaceX


if  [ $withSpaceX == "y" ]; then
	echo "You have choose spacex"
	cp $workdir/bg-spacex.jpg $workdir/theme/background.jpg
else
	echo "You have choose the boat"
	sudo cp $workdir/bg-boat.jpg $workdir/theme/background.jpg
fi

sass $workdir/sass/gdm.scss > gdm.css

sed 's/.*#lockDialogGroup {\n*/#lockDialogGroup {\r\n  background: #2e3436 url(resource:\/\/\/org\/gnome\/shell\/theme\/noise-texture.png);}./' gdm.css

cp $workdir/gdm.css $workdir/theme/gnome-shell.css
cp $workdir/gnome-shell-theme.gresource.xml $workdir/theme/

cd $workdir/theme

glib-compile-resources gnome-shell-theme.gresource.xml && sudo cp gnome-shell-theme.gresource /usr/share/gnome-shell/
cd $workdir
# rm -rf $workdir/theme

echo "enjoy !"
