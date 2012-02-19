// vim: noai:ts=4:sw=4

#include "morse.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

const char morse_code_concat[] =
	" 0 " CODE_0
	" 1 " CODE_1
	" 2 " CODE_2
	" 3 " CODE_3
	" 4 " CODE_4
	" 5 " CODE_5
	" 6 " CODE_6
	" 7 " CODE_7
	" 8 " CODE_8
	" 9 " CODE_9
	" A " CODE_A
	" B " CODE_B
	" C " CODE_C
	" D " CODE_D
	" E " CODE_E
	" F " CODE_F
	" G " CODE_G
	" H " CODE_H
	" I " CODE_I
	" J " CODE_J
	" K " CODE_K
	" L " CODE_L
	" M " CODE_M
	" N " CODE_N
	" O " CODE_O
	" P " CODE_P
	" Q " CODE_Q
	" R " CODE_R
	" S " CODE_S
	" T " CODE_T
	" U " CODE_U
	" V " CODE_V
	" W " CODE_W
	" X " CODE_X
	" Y " CODE_Y
	" Z " CODE_Z
	" ";

const char morse_code[44][6] = {
	  CODE_0
	, CODE_1
	, CODE_2
	, CODE_3
	, CODE_4
	, CODE_5
	, CODE_6
	, CODE_7
	, CODE_8
	, CODE_9
	, "" // :
	, "" // ;
	, "" // <
	, "" // =
	, "" // >
	, "" // ?
	, "" // @
	, CODE_A
	, CODE_B
	, CODE_C
	, CODE_D
	, CODE_E
	, CODE_F
	, CODE_G
	, CODE_H
	, CODE_I
	, CODE_J
	, CODE_K
	, CODE_L
	, CODE_M
	, CODE_N
	, CODE_O
	, CODE_P
	, CODE_Q
	, CODE_R
	, CODE_S
	, CODE_T
	, CODE_U
	, CODE_V
	, CODE_W
	, CODE_X
	, CODE_Y
	, CODE_Z
	, "" };

const char *encode(char c)
{
	if (!isalnum(c))
		return "";
	int index = toupper(c) - '0';
	return morse_code[index];
}

char decode(const char *code)
{
	// sanity check
	if (strspn(code, "-.") != strlen(code))
		return '\0';

	char format[8] = { '\0' };
	sprintf(format, " %.5s ", code);

	const char *found = strstr(morse_code_concat, format);

	if (!found || found < morse_code_concat+2)
		return '\0';

	return *(found-1);
}
