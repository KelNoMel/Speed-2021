#!/bin/dash

# A test for the quit command at a specified regex match

# Quit a seq 18-25 at regex match '/.2/q'
seq 18 25 | ./speed.pl '/.2/q' > output.txt

# Check for numbers that should be outputted
if cat output.txt | grep -q '18'; then
    continue
else
    echo 'Missing number 18'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '19'; then
    continue
else
    echo 'Missing number 19'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '20'; then
    continue
else
    echo 'Missing number 20'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '21'; then
    continue
else
    echo 'Missing number 21'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '22'; then
    continue
else
    echo 'Missing number 22'
    rm output.txt
    exit 1
fi

# Check to see if quit at right location
if cat output.txt | grep -q '23'; then
    echo 'Test failed: 23 was printed'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt