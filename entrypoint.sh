#/bin/bash

cd target

echo -e "\n[+] Setting yarn configuration options for disabling scripts and SSL enforcement checks..."
yarn config set enableStrictSsl false
yarn config set enableScripts false
echo -e "\n[+] Yarn options: "
yarn config | grep 'Script\|StrictSsl'

echo -e "\n[+] Current yarn version: $(yarn --version), updating to latest version..."
yarn set version latest
echo -e "[+] Yarn updated to version: $(yarn --version)\n"

echo -e "\n[+] Performing 'yarn install'..."
yarn install

echo -e "\n[+] Yarn install completed, directory contents:"
ls -la
cd ..

echo -e "\n\n[+] About to run scaresolver, this should fail due to the yarn.lock file still being present. If this file is removed, then this command will complete"
sleep 5

./ScaResolver offline -s target -n app -r results.json
