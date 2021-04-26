#!/bin/dash

# A test for the quit command at a specified line number

# Quit a seq 1-5 at line 4
seq 1 5 | ./speed.pl '4q' > output.txt

# Check to see if right numbers are outputted
if cat output.txt | grep -q '1'; then
    continue
else
    echo 'Missing number 1'
    exit 1
fi

if cat output.txt | grep -q '2'; then
    continue
else
    echo 'Missing number 2'
    exit 1
fi

if cat output.txt | grep -q '3'; then
    continue
else
    echo 'Missing number 3'
    exit 1
fi

if cat output.txt | grep -q '4'; then
    continue
else
    echo 'Missing number 4'
    exit 1
fi

# Check to see if quit at right position
if cat output.txt | grep -q '5'; then
    echo 'Test failed: Line 5 was printed'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt
exit 0