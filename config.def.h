/* See LICENSE for copyright and license details. */

/* Appearance */
static char *font = "JetBrainsMono NFM:pixelsize=14:antialias=true:autohint=true";
/* Spare fonts */
static char *font2[] = {
	"Noto Color Emoji:pixelsize=12:antialias=true:autohint=true",
	"Symbols Nerd Font:pixelsize=14:antialias=true:autohint=true",
};
static int borderpx = 2;
float alpha = 0.98;

/* Kerning / character bounding-box multipliers */
static float cwscale = 1.0;
static float chscale = 0.9;

/* Colors */
static const char *colorname[] = {
	/* 8 normal colors */
	"#000000", /* black */
	"#ff5555", /* red */
	"#50fa7b", /* green */
	"#f1fa8c", /* yellow */
	"#5555ff", /* blue */
	"#ff79c6", /* magenta */
	"#8be9fd", /* cyan */
	"#f8f8f2", /* white */

	/* 8 bright colors */
	"#6272a4", /* black */
	"#ff6e6e", /* red */
	"#69ff94", /* green */
	"#ffffa5", /* yellow */
	"#6e6eff", /* blue */
	"#ff92df", /* magenta */
	"#a4ffff", /* cyan */
	"#ffffff", /* white */

	[255] = 0,

	/* more colors can be added after 255 to use with DefaultXX */
	"#f8f8f2", /* foreground */
	"#282a36", /* background */
};

/* Default colors (colorname index) */
unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
unsigned int defaultcs = 256;
static unsigned int defaultrcs = 257;

/* Terminal settings */
static char *shell = "/bin/sh";
char *utmp = NULL;
char *scroll = NULL;
char *stty_args = "stty raw pass8 nl -echo -iexten -cstopb 38400";
unsigned int tabspaces = 8;
char *termname = "st-256color";
char *vtiden = "\033[?6c";

/* UI settings */
static unsigned int cols = 80;
static unsigned int rows = 24;
static unsigned int mouseshape = XC_xterm;
static unsigned int mousefg = 7;
static unsigned int mousebg = 0;
static unsigned int defaultattr = 11;

/*
 * https://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h4-Functions-using-CSI-_-ordered-by-the-final-character-lparen-s-rparen:CSI-Ps-SP-q.1D81
 * Default style of cursor
 * 0: blinking block
 * 1: blinking block (default)
 * 2: steady block ("█")
 * 3: blinking underline
 * 4: steady underline ("_")
 * 5: blinking bar
 * 6: steady bar ("|")
 * 7: blinking st cursor
 * 8: steady st cursor
 */
static unsigned int cursorstyle = 1;
static Rune stcursor = 0x2603; /* snowman ("☃") */

/* Behavior settings */
wchar_t *worddelimiters = L" ";
static unsigned int doubleclicktimeout = 300;
static unsigned int tripleclicktimeout = 600;
int allowaltscreen = 1;
int allowwindowops = 0;
static double minlatency = 2;
static double maxlatency = 33;
static unsigned int blinktimeout = 800;
static unsigned int cursorthickness = 2;

/*
 * 1: render most of the lines/blocks characters without using the font for
 *    perfect alignment between cells (U2500 - U259F except dashes/diagonals).
 *    Bold affects lines thickness if boxdraw_bold is not 0. Italic is ignored.
 * 0: disable (render all U25XX glyphs normally from the font).
 */
const int boxdraw = 1;
const int boxdraw_bold = 1;

/* braille (U28XX):  1: render as adjacent "pixels",  0: use font */
const int boxdraw_braille = 1;

static int bellvolume = 0;
static uint forcemousemod = ShiftMask;

/* Mouse shortcuts */
static MouseShortcut mshortcuts[] = {
	/* button               function        argument       release */
	{ XK_ANY_MOD,           Button4, kscrollup,      {.i = 5}, 0, /* !alt */ -1 },
	{ XK_ANY_MOD,           Button5, kscrolldown,    {.i = 5}, 0, /* !alt */ -1 },
	{ XK_ANY_MOD,           Button2, selpaste,       {.i = 0}, 1 },
	{ ShiftMask,            Button4, ttysend,        {.s = "\033[5;2~"} },
	{ XK_ANY_MOD,           Button4, ttysend,        {.s = "\031"} },
	{ ShiftMask,            Button5, ttysend,        {.s = "\033[6;2~"} },
	{ XK_ANY_MOD,           Button5, ttysend,        {.s = "\005"} },
};

/* Keyboard shortcuts */
#define MODKEY Mod1Mask
#define TERMMOD (ControlMask|ShiftMask)

static Shortcut shortcuts[] = {
	/* mask                 keysym          function        argument */
	{ TERMMOD,              XK_Prior,       zoom,           {.f = +1} },
	{ TERMMOD,              XK_Next,        zoom,           {.f = -1} },
	{ TERMMOD,              XK_Home,        zoomreset,      {.f =  0} },
	{ TERMMOD,              XK_C,           clipcopy,       {.i =  0} },
	{ TERMMOD,              XK_V,           clippaste,      {.i =  0} },
	{ TERMMOD,              XK_Y,           selpaste,       {.i =  0} },
	{ ShiftMask,            XK_Insert,      selpaste,       {.i =  0} },
	{ TERMMOD,              XK_Num_Lock,    numlock,        {.i =  0} },
	{ ShiftMask,            XK_Page_Up,     kscrollup,      {.i = -1} },
	{ ShiftMask,            XK_Page_Down,   kscrolldown,    {.i = -1} },
	{ XK_ANY_MOD,           XK_Break,       sendbreak,      {.i =  0} },
	{ ControlMask,          XK_Print,       toggleprinter,  {.i =  0} },
	{ ShiftMask,            XK_Print,       printscreen,    {.i =  0} },
	{ XK_ANY_MOD,           XK_Print,       printsel,       {.i =  0} },
};

// Essential key mappings - everything below here handles compatibility
// with various terminal applications and shouldn't need modification
static KeySym mappedkeys[] = { -1 };
static uint ignoremod = Mod2Mask|XK_SWITCH_MOD;
static uint selmasks[] = {
	[SEL_RECTANGULAR] = Mod1Mask,
};

// Include only the required parts of the key array
#include "key.h"
