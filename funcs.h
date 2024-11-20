/* funcs.h -- functions for dungeon */

#ifndef FUNCS_H
#define FUNCS_H

/* If __STDC__ is not defined, don't use function prototypes, void, or
 * const.
 */

#ifdef __STDC__
#define P(x) x
#else
#define P(x) ()
#define void int
#define const
#endif

/* Try to guess whether we need "rb" to open files in binary mode.
 * If this is unix, it doesn't matter.  Otherwise, assume that if
 * __STDC__ is defined we can use "rb".  Otherwise, assume that we
 * had better use "r" or fopen will fail.
 */

#ifdef unix
#define BINREAD "r"
#define BINWRITE "w"
#else /* ! unix */
#ifdef __STDC__
#define BINREAD "rb"
#define BINWRITE "wb"
#else /* ! __STDC__ */
#define BINREAD "r"
#define BINWRITE "w"
#endif /* ! __STDC__ */
#endif /* ! unix */

#define TRUE_ (1)
#define FALSE_ (0)

#define abs(x) ((x) >= 0 ? (x) : -(x))
#define min(a,b) ((a) <= (b) ? (a) : (b))
#define max(a,b) ((a) >= (b) ? (a) : (b))

extern int
    is_protected P((void)),
    wizard P((void));

/*extern int
	protected P((void)),
	wizard P((void)); */

extern void
	more_init P((void)),
	more_output P((const char *)),
	more_input P((void));

extern void
	bug_ P((int, int)),
	cevapp_ P((int)),
	cpgoto_ P((int)),
	cpinfo_ P((int, int)),
	encryp_ P((const char *, char *)),
	exit_ P((void)),
	fightd_ P((void)),
	game_ P((void)),
	gdt_ P((void)),
	gttime_ P((int *)),
	invent_ P((int)),
	itime_ P((int *, int *, int *)), 
	jigsup_ P((int)),
	newsta_ P((int, int, int, int, int)),
	orphan_ P((int, int, int, int, int)),
	princo_ P((int, int)),
	princr_ P((int, int)),
	rdline_ P((char *, int)),
	rspeak_ P((int)),
	rspsb2_ P((int, int, int)),
	rspsub_ P((int, int)),
	rstrgm_ P((void)),
	savegm_ P((void)),
	score_ P((int)),
	scrupd_ P((int)),
	swordd_ P((void)),
	thiefd_ P((void)),
	valuac_ P((int));
extern int
	blow_ P((int, int, int, int, int)),
	fights_ P((int, int)),
	fwim_ P((int, int, int, int, int, int)),
	getobj_ P((int, int, int)),
	schlst_ P((int, int, int, int,  int, int)),
	mrhere_ P((int)),
	oactor_ P((int)),
	rnd_ P((int)),
	robadv_ P((int, int, int, int)), 
	robrm_ P((int, int, int, int, int)),
	sparse_ P((const int *, int, int)),
	vilstr_ P((int)),
	weight_ P((int, int, int));
extern int
	aappli_ P((int)),
	ballop_ P((int)),
	clockd_ P((void)),
	cyclop_ P((int)),
	drop_ P((int)),
	findxt_ P((int, int)),
	ghere_ P((int, int)),
	init_ P((void)),
	lightp_ P((int)),
	lit_ P((int)),
	moveto_ P((int, int)),
	nobjs_ P((int, int)),
	oappli_ P((int, int)),
	objact_ P((void)),
	opncls_ P((int, int, int)),
	parse_ P((char *, int)),
	prob_ P((int, int)),
	put_ P((int)),
	rappli_ P((int)),
	rappl1_ P((int)),
	rappl2_ P((int)),
	rmdesc_ P((int)),
	sobjs_ P((int, int)),
	sverbs_ P((int)),
	synmch_ P((void)),
	take_ P((int)),
	thiefp_ P((int)),
	trollp_ P((int)),
	qempty_ P((int)),
	qhere_ P((int, int)),
	vappli_ P((int)),
	walk_ P((void)),
	winnin_ P((int, int)),
	yesno_ P((int, int, int));

#endif
