#!/bin/dash

# A test for the quit command with comments and extra whitespace

# Quit a seq 1-5 at line 4
seq 1 5 | ./speed.pl    '4   q           #  Nonsensical    format here         '> output.txt

if cat output.txt | grep -q '1'; then
    continue
fi

if cat output.txt | grep -q '2'; then
    continue
fi

if cat output.txt | grep -q '3'; then
    continue
fi

if cat output.txt | grep -q '4'; then
    continue
fi

if cat output.txt | grep -q '5'; then
    echo 'Test failed: Line 5 was printed'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt