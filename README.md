# Assembly Encryption
An Assembly implementation of one cycle of the Advanced Encryption Standard (AES) algorithm as follows:
1) Two Procedures based on interrupts that reads 128 bits from the user and prints the result on
the screen.
1) Macros are used to implement SubBytes(), ShiftRows(), MixColumns(), AddRoundKey() modules, all
work on 128 bits.
1) For the AddRoundkey module, the used key is FF FF FF FF FF FF FF FF FF FF
2) Main program uses the above Macros and subroutines to read the data from the user
and finalize 10 stages of AES and print the result on the screen.
1) The usage of EMU8086 as an emulator for this project.