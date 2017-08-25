#!/bin/sh

if [ ! -x "$1" ]; then
	echo "The file isn't exist or executable."
	exit 0
fi
if [ ! -d "./mylib" ];then
	mkdir ./mylib
fi
ldd TicketMaster | grep -P -o "(?<=\=\> ).*?(?= \()" | xargs -i cp {} ./mylib/
cp $1 ./program
tar -zcvf packages.tar.gz program mylib
echo '#!/bin/sh' > start.sh
echo 'if [ ! -d "./mylib" ]; then' >> start.sh
echo 'sed -n -e "1,/^exit 0$/!p" $0 > "./packages.tar.gz" 2>/dev/null' >> start.sh
echo 'tar -zxf "./packages.tar.gz"' >> start.sh
echo 'chmod +x program'
echo 'fi' >> start.sh
#echo '/lib/ld-linux.so.2 --library-path ./mylib ./program' >> start.sh #for 32bit program
echo '/lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 --library-path ./mylib ./program' >> start.sh #for 64bit program
echo 'exit 0' >> start.sh
cat start.sh packages.tar.gz > program.bin
chmod +x "program.bin"
rm packages.tar.gz program start.sh
rm -rf mylib
