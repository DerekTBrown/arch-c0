#!/bin/bash
cd "$TRAVIS_BUILD_DIR/deploy"

# Obtain mksrcinfo
echo "Obtaining mksrcinfo";
wget https://www.archlinux.org/packages/community/any/pkgbuild-introspection/download/ -O pkgbuild-introspection.tar.xz
tar -Jxf pkgbuild-introspection.tar.xz usr/bin/mksrcinfo
PATH="$PATH:$(pwd)/usr/bin"

# Add Build Files
echo "Clone AUR Upstream"
ssh-keyscan aur.archlinux.org >> ~/.ssh/known_hosts
git clone ssh://aur@aur.archlinux.org/c0.git aur

echo "Make Source Info";
cp ../PKGBUILD aur
cd aur
mksrcinfo

echo "Prepare AUR Commit"
git add PKGBUILD .SRCINFO
git config user.email "derek@allderek.com"
git config user.name "Derek Brown"
git commit . -m "Release $TRAVIS_TAG via TravisCI"

# Deploy to AUR
echo "Push to AUR";
git push origin master
