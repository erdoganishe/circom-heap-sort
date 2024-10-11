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

## Comparison

| ALGO |    LEN   | BITS  | CONSTRAINTS |
|:-----|:--------:|:-----:|------------:|
| Heap | 7        | 4     | 189         |
| NS   | 7        | 4     | 206         |
| Heap | 7        | 10    | 315         |
| NS   | 7        | 10    | 242         |
| Heap | 7        | 30    | 735         |
| NS   | 7        | 30    | 362         |
| Heap | 32       | 4     | 4464        |
| NS   | 32       | 4     | 4156        |
| Heap | 32       | 10    | 7440        |
| NS   | 32       | 10    | 4342        |
| Heap | 32       | 30    | 17360       |
| NS   | 32       | 30    | 4962        |
| Heap | 100      | 4     | 44550       |
| NS   | 100      | 4     | 40196       |
| Heap | 100      | 10    | 74250       |
| NS   | 100      | 10    | 40790       |
| Heap | 100      | 30    | 173250      |
| NS   | 100      | 30    | 42770       |
| Heap | 256      | 2     | 228480      |
| NS   | 256      | 2     | 262142      |
| Heap | 256      | 3     | 261120      |
| NS   | 256      | 3     | 262397      |
| Heap | 256      | 4     | 293760      |
| NS   | 256      | 4     | 262652      |
| Heap | 256      | 10    | 489600      |
| NS   | 256      | 10    | 264182      |
| Heap | 256      | 30    | 1142400     |
| NS   | 256      | 30    | 269282      |
