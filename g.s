// GalaxyOS 0.05
// By Jeremy Reimer
//
// Version info:
//  0.01 July 2, 2024 Prints welcome message to stdout, that's it
//  0.04 July 17, 2024 Prints prompt, allows stdin input, echoes input back
//  0.05 July 30, 2024 Counts parenthesis and prints error if they don't match
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

// Go through input string character by character, print out, and parse into LISP cells

_parse: adrp X11, inputmsg@PAGE         // X11 is the current address of inputmsg (first character)
        add X11, X11, inputmsg@PAGEOFF  //
        mov X13, #0                     // X13 is our parenthesis counting register, starts at zero
        adrp X14, lispcells@PAGE        // X14 is our pointer to the current LISP cell address
        add X14, X14, lispcells@PAGEOFF // 
        adrp X15, lispcells@PAGE        // X15 is our backup pointer to a previous LISP cell for recursion
        add X15, X15, lispcells@PAGEOFF // 
        adrp X19, symbols@PAGE          // X19 is the current pointer to the SYMBOLS list
        add X19, X19, symbols@PAGEOFF   //
                                        // W20 is the previous character we looked at
_loop1: mov X2, #1                      // we are only printing one byte
        mov X0, #1                      // Stdout
        mov X1, X11                     // copy current address into argument register X1
        mov X16, #4                     // 4 is SYS_WRITE
        svc 0                           // make system call 
        ldrb W12, [X11]                 // load a byte from memory contents at X11 into W12
        mov W20, W12                    // make a copy of this character in W20 for later
        cmp w12, #40                    // is the character a "("?
        b.ne _comp1                     // if not, skip to next check
        add X13, X13, #1                // increment parenthesis counter by one
_comp1: cmp W12, #41                    // is the character a ")"?
        b.ne _comp2                     // if not, skip to next check
        sub X13, X13, #1                // decrement parenthesis counter by one
_comp2: add X11, X11, #1                // add 1 to address to point to next character
        ldrb w12, [X11]                 // load a byte from memory contents at X11 into X12
        cmp w12, #10                    // check for end of line char, are we at the end of the input string?
        b.ne _loop1                     // jump to loop if not

        adrp X1, newline@PAGE           // IF WE'RE DONE, PRINT A NEWLINE
        add X1, X1, newline@PAGEOFF     // required when using @PAGE format
        mov X2, #1                      // print just one byte
        mov X16, #4                     // 4 is SYS_WRITE
        svc 0                           // print the newline

// Display error message if parenthesis don't match

_par1:  cmp X13, #0                     // Is the parenthesis count zero, aka, do parentheses match?
        b.eq _par2                      // If so, skip past the error message
        adrp X1, parencountmsg@PAGE     // prompt for parenthesis count message
        add X1, X1, parencountmsg@PAGEOFF // as above
        mov X2, #31                     // length of parenthesis prompt
        mov X16, #4                     // SYS_WRITE
        svc 0                           // print it out

// infinite loop for now
_par2:  b _prompt                        // go back to new prompt

// Setup the parameters to exit the program
// and then call macOS to do it.

        mov     X0, #0       // Use 0 return code
        mov     X16, #1      // Service command code 1 terminates program
        svc     0            // Call macOS to terminate program

.data
        hellomessage:      .ascii  "Initializing GalaxyOS 0.05...\n"
        promptmsg:         .ascii  "\nG) "
        newline:           .ascii  "\n"
        parencountmsg:     .ascii  "ERROR: Mismatched parentheses.\n"
        inputmsg:          .space 1024
        lispcells:         .space 8192
        symbols:           .space 8192
