#!/bin/bash

workdir=$(pwd)
if [ ! -d ${workdir}/extracted ]; then
  mkdir -p ${workdir}/extracted
fi

bakFile=$(find . -type f -name "*.gresource.bak" | sed 's|^\./||') 
file=$(find . -type f -name "*.gresource" | sed 's|^\./||') 
if [ -n "$bakFile" ]; then
  rm -rf $file
  mv $bakFile $file
fi
#echo "$file"

for r in `gresource list $file`; do
  newfile="extracted$r"
  extractedFolder=$(echo "$newfile" | sed 's/\/[^/]*$//') 
  mkdir -p $extractedFolder
  gresource extract $file $r > $newfile
done

svgFiles=$(find . -type f -name "*.svg")

for f in `echo $svgFiles`; do
  sed -i 's/([0-9]\{1,3\},[0-9]\{1,3\},[0-9]\{1,3\})/(255, 255, 255)/g' "$f"
done

mv $file "$file.bak"
glib-compile-resources --sourcedir=extracted/org/gnome/Shell/Extensions/supergfxctl-gex/icons/scalable/ --target=$file gnome-extension.xml
