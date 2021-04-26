#!/bin/dash

# A test for the substitution command with the g option

# Print a seq 18-22
echo i like saying i | ./speed.pl 's/i/b/' > output.txt

if cat output.txt | grep -q 'b like saying i'; then
    continue
else
    echo 'Wrong output'
    rm output.txt
    exit 1
fi

echo i like saying i | ./speed.pl 's/i/b/g' > output.txt

if cat output.txt | grep -q 'b lbke saybng b'; then
    continue
else
    echo 'Wrong output'
    rm output.txt
    exit 1
fi

echo 'Test passed'
rm output.txt