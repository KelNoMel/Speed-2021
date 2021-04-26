#!/bin/dash

# A test for the print command with option -n

# Print a seq 1 5
seq 1 5 | ./speed.pl -n '4p' > output.txt

# Check for numbers that should be missing from output
if cat output.txt | grep -q '1'; then
    echo '1 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '2'; then
    echo '2 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '3'; then
    echo '3 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '5'; then
    echo '5 Should not be in output'
    rm output.txt
    exit 1
fi

# Check for numbers that should be printed
uniq -c output.txt > dupes.txt
rm output.txt

if cat dupes.txt | grep -q '1 4'; then
    continue
else
    echo 'Incorrect instances of number 4'
    rm dupes.txt
    exit 1
fi

echo 'Test passed'
rm dupes.txt