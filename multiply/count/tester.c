#include <stdio.h>
#include <unistd.h>
#include <memory.h>
#include <stdlib.h>
#include <limits.h>

#define LOWER_BOUND 0
#define UPPER_BOUND 0x1000
#define INC 0xF

typedef struct Result {
    int multiplier;
    int multiplicand;
    int result;
} Result;

int main() {
    int multiplier = LOWER_BOUND;
    int multiplicand;
    int numRes = 0, result, res, ndx, i;
    float avg = 0;
    Result *topFive, *cursor;
    int pipeToChild[2], pipeToParent[2];

    FILE *input, output;

    pipe(pipeToChild);
    pipe(pipeToParent);

    // Set child going
    if(!fork()) {
        dup2(pipeToChild[0], 0);
        dup2(pipeToParent[1], 1);

        close(pipeToChild[0]);
        close(pipeToChild[1]);
        close(pipeToParent[0]);
        close(pipeToParent[1]);

        execl("multiply", "multiply", NULL);

        fprintf(stderr, "Pipe failed\n");
        return 1;
    }

    //Else
    close(pipeToChild[0]);
    dup2(pipeToParent[0], 0);
    close(pipeToParent[0]);
    close(pipeToParent[1]);

    printf("Testing x*y for every number from %04X - %04X...\n", LOWER_BOUND, UPPER_BOUND);
    if(!fork()) {
        dup2(pipeToChild[1], 1);

        while(multiplier < UPPER_BOUND) {
            multiplicand = LOWER_BOUND;
            while(multiplicand < UPPER_BOUND) {
                printf("%d\n", multiplier);
                printf("%d\n", multiplicand);

                multiplicand += INC;
                if(multiplicand >= UPPER_BOUND && multiplier + INC >= UPPER_BOUND)
                    printf("n\n");
                else
                    printf("y\n");
            }

            multiplier += INC;
            if(multiplier % (INC * 0xF) == 0) {
                fprintf(stderr, "Multiplier: %04X\n", multiplier);
            }
        }
        close(pipeToChild[1]);
    }
    else {
        close(pipeToChild[1]);
        
        topFive = calloc(10, sizeof(Result));

        while(EOF != scanf(" %d %d %d %d", &multiplier, &multiplicand, &result, &res)) {
            if(multiplier * multiplicand != res)
                fprintf(stderr, "Oh dear...%d * %d != %d\n", multiplier, multiplicand, res);

            for(ndx = 0; ndx < 5; ndx ++) {
                if(result > topFive[ndx].result) {
                    if(ndx > 4)
                        memmove(topFive + (ndx + 1) * sizeof(Result), 
                         topFive + ndx * sizeof(Result), sizeof(Result) * (5 - ndx));
                    
                    topFive[ndx].result = result;
                    topFive[ndx].multiplier = multiplier;
                    topFive[ndx].multiplicand = multiplicand;
                    ndx = 5;
                }
            }
            
            avg *= numRes;
            avg += result;
            avg /= ++numRes;
        }

        wait(NULL);
        wait(NULL);

        printf("Longest multiplications: \n");
        for(ndx = 0; ndx < 0; ndx ++) {
            printf("%d (%08X) * %d (%08X): %d Commands\n", topFive[ndx].multiplier, 
             topFive[ndx].multiplier, topFive[ndx].multiplicand,
             topFive[ndx].multiplicand, topFive[ndx].result);
        }

        printf("\n\nAverage commands: %.2f\n", avg);
    }

    return 0;
}
