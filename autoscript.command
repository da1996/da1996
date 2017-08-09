#!/bin/bash
clear
echo "Questo script si occupera di: generare il file deb e aggiungerlo all'indice dei pacchetti"
echo "Inserisci il percorso della cartella che contiene i file del deb"
read path
cd "$path"
mkdir DEBIAN
touch DEBIAN/control
echo "Inserisci i seguenti campi necessari per creare il file deb"
echo "Name:"
read name
echo "Architecture:"
read architecture
echo "Package:"
read package
echo "Version:"
read version
echo "Website:"
read website
echo "Icon:"
read icon
echo "Maintainer:"
read maintainer
echo "Description:"
read description
echo "Section:"
read section
echo "Vuoi creare lo script Pre-install ?"
read prei
if [ "$prei" == "si" ]; then
touch DEBIAN/preinst
echo "#!/bin/bash" > DEBIAN/preinst
echo "Inserisci i comandi nella schermata che apparirà a breve"
sleep 3
nano DEBIAN/preinst
chmod -R 775 DEBIAN/preinst
fi
echo "Vuoi creare lo script Post-install ?"
read posti
if [ "$posti" == "si" ]; then
touch DEBIAN/postinst
echo "#!/bin/bash" > DEBIAN/postinst
echo "Inserisci i comandi nella schermata che apparirà a breve"
sleep 3
nano DEBIAN/postinst
chmod -R 775 DEBIAN/postinst
fi
echo "Vuoi creare lo script Pre-remove ?"
read prerm
if [ "$prerm" == "si" ]; then
touch DEBIAN/prerm
echo "#!/bin/bash" > DEBIAN/prerm
echo "Inserisci i comandi nella schermata che apparirà a breve"
sleep 3
nano DEBIAN/prerm
chmod -R 775 DEBIAN/prerm
fi
echo "Vuoi creare lo script Post-remove ?"
read postrm
if [ "$postrm" == "si" ]; then
touch DEBIAN/postrm
echo "#!/bin/bash" > DEBIAN/postrm
echo "Inserisci i comandi nella schermata che apparirà a breve"
sleep 3
nano DEBIAN/postrm
chmod -R 775 DEBIAN/postrm
fi
echo "Architecture: $architecture
Name: $name
Package: $package
Version: $version
Website: $website
Size: 1
Icon: $icon
Maintainer: $maintainer
Description: $description
Section: $section
" > DEBIAN/control
echo "Inserisci la cartella della repo"
read repo
echo "Inserisci nome del deb"
read nome
genera=$($repo/dpkg-deb -b "$path" "$repo/debs/$nome.deb")
echo "Pacchetto deb generato con successo"
md55=$(md5 -q "$repo/debs/$nome.deb")
shamsum1=$(shasum -a 1 "$repo/debs/$nome.deb" | awk '{print $1}')
shasum256=$(shasum -a 256 "$repo/debs/$nome.deb" | awk '{print $1}')
size=$(perl -e '@x=stat(shift);print $x[7]' "$repo/debs/$nome.deb")
echo "
Name: $name
Architecture: $architecture
Package: $package
Version: $version
Filename: debs//$nome.deb
Conflicts: com.pphelper.untether8x
Website: $website
Icon: $icon
Maintainer: $maintainer
Description: $description
Section: $section
MD5sum: $md55
SHA1: $shamsum1
SHA256: $shasum256
Size: $size" >> "$repo/Packages"
cp "$repo/Packages" "$repo/Packages2"
bzip2 -z -f "$repo/Packages"
mv "$repo/Packages2" "$repo/Packages"
