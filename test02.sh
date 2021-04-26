#!/bin/dash

# A test for the print command without instructions

# Print a seq 1 5
seq 1 5 | ./speed.pl 'p' > print.txt
uniq -c print.txt > output.txt
rm print.txt

# Check that every line is duplicated
if cat output.txt | grep -q '2 1'; then
    continue
else
    echo 'Incorrect instances of number 1'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2 2'; then
    continue
else
    echo 'Incorrect instances of number 2'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2 3'; then
    continue
else
    echo 'Incorrect instances of number 3'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2 4'; then
    continue
else
    echo 'Incorrect instances of number 4'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2 5'; then
    continue
else
    echo 'Incorrect instances of number 5'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt