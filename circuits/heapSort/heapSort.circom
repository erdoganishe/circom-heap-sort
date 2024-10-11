pragma circom  2.1.9;

include "circomlib/circuits/comparators.circom";

template MaxToRight(LEN, BITS, left, right){
    signal input in[LEN];
    signal output out[LEN];

    for (var i = 0; i < LEN; i++){
        if (i!=right && i!=left ){
            out[i]<==in[i];
        }
    }

    component isLess = LessThan(BITS);
    isLess.in[0] <== in[left];
    isLess.in[1] <== in[right];

    signal tmp[2][2];
    tmp[0][0] <== in[left] * isLess.out;
    tmp[0][1] <== in[right] * (1 - isLess.out);
    tmp[1][0] <== in[right] * isLess.out;
    tmp[1][1] <== in[left] * (1 - isLess.out);

    out[left] <== tmp[0][0] + tmp[0][1];
    out[right] <== tmp[1][0] + tmp[1][1];

}

template SwapWithZero(LEN, right){
    signal input in[LEN];
    signal output out[LEN];
    for (var i = 1; i < LEN; i++){
        if (i!=right){
            out[i]<==in[i];
        }
        else{
            out[i] <== in[0];
        }
    }
    out[0]<==in[right];

}

template Heapify(LEN, BITS, LEVELS, sorted_on_levels){
    signal input in[LEN];
    signal output out[LEN];

    component processLevel[LEVELS - 1];

    var process_level_counter = 0;

    for( var i = LEVELS-1; i > 0; i--){
        processLevel[process_level_counter] = ProcessLevel(LEN, BITS, i, sorted_on_levels[i]);
        if (process_level_counter == 0){
            processLevel[0].in <== in;
        } else {
            processLevel[process_level_counter].in <== processLevel[process_level_counter-1].out;
        }
        process_level_counter++;
    }
    var num_sorted = 0;
    for (var i = 0; i < LEVELS; i++){
        num_sorted += sorted_on_levels[i];

    }
    component lastSwap = SwapWithZero(LEN, LEN - num_sorted - 1);
    lastSwap.in <== processLevel[LEVELS - 2].out;

    out <== lastSwap.out;
}

template ProcessLevel(LEN,BITS, level, num_sorted){
    assert(level >= 1);
    signal input in[LEN];
    signal output out[LEN];


    if (num_sorted == 2**level){

        out <== in;
        
    } else {

        var SWAPS_NEEDED = (2**(level+1)- 1 - num_sorted%2 - num_sorted - (2**level - 1) + (2**(level+1) - 1 - num_sorted%2 - num_sorted - (2**level - 1))%2)\2 +
        ((2**(level+1) - 1 - num_sorted - 2**level) + ((2**(level+1) - 1 - num_sorted - 2**level)%2))\ 2; 
        
        if (num_sorted % 2 == 1) SWAPS_NEEDED++;

        var swap_counter = 0;
        component maxToRight[SWAPS_NEEDED];

        for (var i = 2**level - 1; i < 2**(level+1) - 1 - num_sorted%2 - num_sorted; i+=2){
            maxToRight[swap_counter] = MaxToRight(LEN, BITS, i, i+1);
            if (swap_counter == 0){
                maxToRight[swap_counter].in <== in;
            } else {
                maxToRight[swap_counter].in <== maxToRight[swap_counter-1].out;
            }
            swap_counter++;
        }
        for (var i = 2**level; i < 2**(level+1) - 1 - num_sorted; i+=2){
            maxToRight[swap_counter] = MaxToRight(LEN, BITS, i, (i-1)\2);
            maxToRight[swap_counter].in <== maxToRight[swap_counter-1].out;
            swap_counter++;
        }
        if (num_sorted % 2 == 1){
            maxToRight[SWAPS_NEEDED-1] = MaxToRight(LEN, BITS, 2**(level+1)-2-num_sorted, (2**(level+1)-3-num_sorted)\2);
            if (SWAPS_NEEDED == 1){
                maxToRight[0].in <== in;
            }
            else{
                maxToRight[SWAPS_NEEDED-1].in <== maxToRight[SWAPS_NEEDED-2].out;
            }   
        }

        out <== maxToRight[SWAPS_NEEDED-1].out;
       
    }

}

template HeapSort(len, BITS){

    assert(len >= 2);

    signal input in[len];
    signal output out[len];

    var LEVELS = 1;
    while (2**LEVELS < len){
        LEVELS++;
    }
    var LEN = 2**LEVELS - 1;

    var num_sorted = LEN-len;
    var sorted_on_levels[LEVELS];
    var current_level = LEVELS-1;
    for (var i = 0; i < LEVELS-1; i++){
        sorted_on_levels[i] = 0;
    }
    sorted_on_levels[LEVELS-1] = num_sorted;

    signal startingArr[LEN];
    for (var i = 0; i < len; i++){
        startingArr[i] <== in[i]; 
    }
    for (var i = len; i < LEN; i++){
        startingArr[i] <== 0;
    }

    component heapify[len-1];

    for (var i = 0; i < len-1; i++){
        heapify[i] = Heapify(LEN, BITS, LEVELS, sorted_on_levels);
        if (i == 0) {
            heapify[i].in <== startingArr;
        }
        else{
            heapify[i].in <== heapify[i-1].out;
        }
        sorted_on_levels[current_level]++;
        if (sorted_on_levels[current_level] == 2**current_level){
            current_level--;
        } 
    }
    for (var i = 0; i < len; i++){
        out[i] <== heapify[len-2].out[i];
        log(out[i]);
    }
}