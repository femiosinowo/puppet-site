#!/bin/bash

/usr/local/bin/rake spec | tee output.txt

if ! grep -q 'FAILED' output.txt ; then
    /bin/echo -e "\e[1;32mTest successful\e[0m"
    /bin/echo '0' > indicator.txt
else
    /bin/echo -e "\e[1;31mTest failed\e[0m"
    /bin/echo '1' > indicator.txt
fi
