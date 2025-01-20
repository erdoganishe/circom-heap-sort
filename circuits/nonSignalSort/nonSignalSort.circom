pragma circom  2.1.6;

include "circomlib/circuits/comparators.circom";
include "circomlib/circuits/bitify.circom";

function swap (arr, left, right) {
    var tmp = arr[left];
    arr[left] = arr[right];
    arr[right] = tmp;
    return arr;
}


template NonSignalSort(LEN, BITS){

    signal input in[LEN];
    signal output out[LEN];

    component bitLengthCheck[LEN];
    for(var i = 0; i < LEN; i++){
        bitLengthCheck[i] = Num2Bits(BITS);
        bitLengthCheck[i].in <== in[i];
    }

    var arr[LEN];
    for(var i = 0; i < LEN; i++){
        arr[i] = in[i];
    }
    for(var i = 0; i < LEN; i++){
        for(var j = 0; j < LEN-1; j++){
            if(arr[j]>arr[j+1]){
                arr = swap(arr, j, j+1);
            }
        }
    }

    for(var i = 0; i < LEN; i++){
        out[i] <-- arr[i];
        // log(out[i]);
    }
    //check if sorted and the same array
    component isLess[LEN-1];
    for (var i = 0; i < LEN-1; i++){
        isLess[i] = LessThan(BITS);
        isLess[i].in[0] <== out[i+1];
        isLess[i].in[1] <== out[i];
        isLess[i].out === 0;
    }

    component isEqualWithIn[LEN][LEN-1];
    component isEqualWithOut[LEN][LEN];
    signal checkersIn[LEN][LEN];
    signal checkersOut[LEN][LEN+1];
    

    for (var i = 0; i < LEN; i++){
        checkersIn[i][0] <== 0;
        for (var j = 0; j < LEN; j++ ){
            if (i!=j){
                isEqualWithIn[i][j - (j>i)] = IsEqual();
                isEqualWithIn[i][j - (j>i)].in[0] <== in[i];
                isEqualWithIn[i][j - (j>i)].in[1] <== in[j];
                checkersIn[i][j+1 - (j>i)] <== checkersIn[i][j - (j>i)] + isEqualWithIn[i][j - (j>i)].out;
            }
        }
    }

    for (var i = 0; i < LEN; i++){
        checkersOut[i][0] <== 0;
        for (var j = 0; j < LEN; j++ ){
            isEqualWithOut[i][j] = IsEqual();
            isEqualWithOut[i][j].in[0] <== in[i];
            isEqualWithOut[i][j].in[1] <== out[j];
            checkersOut[i][j+1] <== checkersOut[i][j] + isEqualWithOut[i][j].out;
        }
    }

    for(var i = 0; i < LEN; i++){
        checkersOut[i][LEN] - checkersIn[i][LEN-1] === 1;
    }
}