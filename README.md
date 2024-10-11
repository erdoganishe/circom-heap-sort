# Circom sorting

## Usage

Install the dependencies before running the circuits.

```console
npm i
```

To run tests use npm script command.

```console
npm run test
```

## Sorting

Here is implementation of 2 algos for sorting in circom. One sorting signal array as signals (heap sort), second one sorts array as var and then make checks for result.

Both sorting has the same compile params:

```circom
template HeapSort(LEN, BITS){...
template NonSignalSort(LEN, BITS){...
```

LEN is lenght of input array that we want to sort.
BITS is lenght in bits of the biggest num in array. We can`t compare signals using "<" or ">" in circom, so we use LessThan component from circom lib, which depends on input signals len.

## Heap sort

For "signal" algo heap sort was choosen because it is data indifferent algo: best case == average case == worst case (because of circom restrictions, every case is the worst one).

For this one we have this num of constraints: 

-  HeapSort(7,4) --> 189
-  HeapSort(100, 10) --> 74250
-  HeapSort(256, 10) --> 489600

## Non-signal sort

For "non-signal" sort we use var the same as input, use any sorting algo for sorting it (we don`t have previous signal limitations as it is variable, not signal now), and then check for result to avoid security issues(withness manipulation). We should do 2 checks: array should be sorted and array should contain all the same elements.

For this one we have this num of constraints: 

-  NonSignalSort(7,4) --> 206
-  NonSignalSort(100, 10) --> 40790
-  NonSignalSort(256, 10) --> 264182