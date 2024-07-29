# GalaxyOS - An experimental LISP environment for macOS

![image](galaxy-os-logo.jpg|width=480)

## Introduction

GalaxyOS is a LISP interpreter written in 64-bit ARM assembly code that will run on any macOS computer
that uses Apple Silicon.

The purpose of GalaxyOS is to learn how to write an extremely fast LISP environment that can 
connect to and drive a graphical interface using third party libraries. 

The goal is to create something that is the spiritual successor to the old LISP machines from the 1970s
and 1980s. These machines ran unique graphical environments that were completely interactive -- the user 
could control and change anything on the system, including the code to run the interface itself. Because
they ran on custom CPU hardware, they were eventually supplanted by more standard workstations that ran
Unix, and eventually by commodity PC clone hardware.

However, it is universally felt that something special was lost with the death of the LISP machines. The
spirit of exploration and customization, and the raw power of LISP, got lost in the shift towards the
standards of Unix, C, and x86 chips.

GalaxyOS is an attempt to bring this ancient magic back into the world.

## Building and running Galaxy OS

Right now, GalaxyOS is a work in progress. It only runs on Macintosh computers that have Apple Silicon.

Future versions will run on PC compatibles that have x86 chips.

### Requirements

1. Install Apple XCode from the macOS App Store.
2. Install XCode command line tools. Open a terminal prompt, and type:
    ```xcode-select --install```

### Building

1. Open a terminal prompt, and navigate to the directory you downloaded GalaxyOS.
2. Type:
    ```make```

### Running

1. Open a terminal prompt, and navigate to the directory you downloaded GalaxyOS.
2. Type:
    ```./g```

## Using GalaxyOS

Right now, GalaxyOS provides a prompt and will echo the input. That's all I've written so far!

Future versions will provide a basic LISP interpreter that will interpret this input.

Eventually, a full LISP environment will be provided that will launch on startup.

## Version

Current version: 0.04 July 17, 2024 Prints prompt, allows stdin input, echoes input back
