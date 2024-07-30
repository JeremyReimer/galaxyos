// GalaxyOS 0.04
// By Jeremy Reimer
//
// Version info:
//  0.01 July 2, 2024 Prints welcome message to stdout, that's it
//  0.04 July 17, 2024 Prints prompt, allows stdin input, echoes input back
//
// X0-X2 - parameters to macOS function services
// X16 - macOS function number
//
.global _start   // Provide program starting address to linker
.p2align 3       // Pads storage boundary to 8 bytes

// Starting from scratch, goals are:
// 1. Get prompt printing
// 2. Get input into a string with stdin (max chars? Something ridiculously high)
// 3. Repeat output to screen with stdout
// 4. Parse input into LISP cells
// 5. Evaluate LISP cells
// 6. Print output (finishing REPL)
// 7. Continue through to next expression, or if finished, return to prompt


// Setup the parameters to print welcome message
// and then make a macOS Unix call to do it.

_start: mov X0, #1                      // 1 = StdOut put into X0
        adrp X1, hellomessage@PAGE      // get address of string to print, put in X1 (@PAGE finds address anywhere)
        add X1, X1, hellomessage@PAGEOFF// required when using @PAGE format
        mov X2, #30                     // length of our string, put in to X2
        mov X16, #4                     // Put macOS write system call (SYS_WRITE) into X16 for svc instruction
        svc 0                           // Make exception call to macOS system to output the string

_prompt: mov X0, #1                     // StdOut again
         adrp X1, promptmsg@PAGE        // prompt string to print
         add X1, X1, promptmsg@PAGEOFF  // required when using @PAGE format
         mov X2, #4                     // length of prompt string
         mov X16, #4                    // prepare system call
         svc 0                          // Make system call to print prompt

_input:  mov X0, #0                     // Stdin
         adrp X1, inputmsg@PAGE         // address of blank space
         add X1, X1, inputmsg@PAGEOFF   // required when using @PAGE format
         mov X2, #1024                  // max length is 1024
         mov X16, #3                    // 3 is SYS_READ
         svc 0                          // make system call to input

// test echo of input
//_echo:   mov X2, X0                     // move byte count from X0 to X2 (the nbyte for write syscall)
//         mov x0, #1                     // StdOut
//         adrp X1, inputmsg@PAGE         // address of input message
//         add X1, X1, inputmsg@PAGEOFF   // required when using @PAGE format
//         //mov X2, #1024                // length of input (not required? maybe it's already living in X2)
//         mov X16, #4                    // 4 is SYS_WRITE
//         svc 0

// Go through input string character by character and print out

_parse: adrp X11, inputmsg@PAGE          // current address of inputmsg (first character)
        add X11, X11, inputmsg@PAGEOFF
_loop1: mov X2, #1                      // we are only printing one byte
        mov X0, #1                      // Stdout
        mov X1, X11                     // copy current address into argument register X1
        mov X16, #4                     // 4 is SYS_WRITE
        svc 0                           // make system call 
        adrp X1, newline@PAGE           // newline character to print at end of each char
        add X1, X1, newline@PAGEOFF     // required when using @PAGE format
        mov X2, #1                      // print just one byte
        mov X16, #4                     // 4 is SYS_WRITE
        svc 0                           // print the newline
        add X11, X11, #1                // add 1 to address to point to next character
        ldrb w12, [X11]                 // load a byte from memory contents at X11 into X12
        CMP w12, #10                    // check for end of line char, are we at the end of the input string?
        b.ne _loop1                     // jump to loop if not



// infinite loop test
        b _prompt                        // go back to new prompt

// Setup the parameters to exit the program
// and then call macOS to do it.

        mov     X0, #0       // Use 0 return code
        mov     X16, #1      // Service command code 1 terminates program
        svc     0            // Call macOS to terminate program

.data
        hellomessage:      .ascii  "Initializing GalaxyOS 0.04...\n"
        promptmsg:         .ascii  "\nG) "
        newline:           .ascii  "\n"
        inputmsg:          .space 1024
