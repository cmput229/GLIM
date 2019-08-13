rm -f test.s
cat demo.s > test.s
cat GLIM.s >> test.s
spim -f test.s
rm -f test.s