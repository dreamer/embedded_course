// vim: noai:ts=4:sw=4

#ifndef MORSE_H
#define MORSE_H

/** Naive implementation of morse code encoding and decoding.
 */

#define CODE_0 "-----"
#define CODE_1 ".----"
#define CODE_2 "..---"
#define CODE_3 "...--"
#define CODE_4 "....-"
#define CODE_5 "....."
#define CODE_6 "-...."
#define CODE_7 "--..."
#define CODE_8 "---.."
#define CODE_9 "----."
#define CODE_A ".-"
#define CODE_B "-..."
#define CODE_C "-.-."
#define CODE_D "-.."
#define CODE_E "."
#define CODE_F "..-."
#define CODE_G "--."
#define CODE_H "...."
#define CODE_I ".."
#define CODE_J ".---"
#define CODE_K "-.-"
#define CODE_L ".-.."
#define CODE_M "--"
#define CODE_N "-."
#define CODE_O "---"
#define CODE_P ".--."
#define CODE_Q "--.-"
#define CODE_R ".-."
#define CODE_S "..."
#define CODE_T "-"
#define CODE_U "..-"
#define CODE_V "...-"
#define CODE_W ".--"
#define CODE_X "-..-"
#define CODE_Y "-.--"
#define CODE_Z "--.."

const char *encode(char c);

char decode(const char *code);

#endif // MORSE_H

