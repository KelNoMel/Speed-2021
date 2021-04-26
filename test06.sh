#!/bin/dash

# A test for the delete command with regex range

# Print a seq 1 15
seq 1 15 | ./speed.pl '2,/.3/d' > output.txt

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

if cat output.txt | grep -q '11'; then
    echo '11 Should not be in output'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '12'; then
    echo '11 Should not be in output'
    rm output.txt
    exit 1
fi

# Check for numbers that should be printed
if cat output.txt | grep -q '1'; then
    continue
else
    echo 'Missing number 1'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '14'; then
    continue
else
    echo 'Missing number 14'
    rm output.txt
    exit 1
fi

if cat output.txt | grep -q '15'; then
    continue
else
    echo 'Missing number 15'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt