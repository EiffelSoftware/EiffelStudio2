#!/usr/bin/env perl
#
# ====================================================================
# Written by Andy Polyakov <appro@fy.chalmers.se> for the OpenSSL
# project. Rights for redistribution and usage in source and binary
# forms are granted according to the OpenSSL license.
# ====================================================================
#
# whirlpool_block_mmx implementation.
#
*SCALE=\(2); # 2 or 8, that is the question:-) Value of 8 results
# in 16KB large table, which is tough on L1 cache, but eliminates
# unaligned references to it. Value of 2 results in 4KB table, but
# 7/8 of references to it are unaligned. AMD cores seem to be
# allergic to the latter, while Intel ones - to former [see the
# table]. I stick to value of 2 for two reasons: 1. smaller table
# minimizes cache trashing and thus mitigates the hazard of side-
# channel leakage similar to AES cache-timing one; 2. performance
# gap among different µ-archs is smaller.
#
# Performance table lists rounded amounts of CPU cycles spent by
# whirlpool_block_mmx routine on single 64 byte input block, i.e.
# smaller is better and asymptotic throughput can be estimated by
# multiplying 64 by CPU clock frequency and dividing by relevant
# value from the given table:
#
#		$SCALE=2/8	icc8	gcc3	
# Intel P4	3200/4600	4600(*)	6400
# Intel PIII	2900/3000	4900	5400
# AMD K[78]	2500/1800	9900	8200(**)
#
# (*)	I've sketched even non-MMX assembler, but for the record
#	I've failed to beat the Intel compiler on P4, without using
#	MMX that is...
# (**)	... on AMD on the other hand non-MMX assembler was observed
#	to perform significantly better, but I figured this MMX
#	implementation is even faster anyway, so why bother? As for
#	pre-MMX AMD core[s], the improvement coefficient is more
#	than likely to vary anyway and I don't know how. But the
#	least I know is that gcc-generated code compiled with
#	-DL_ENDIAN and -DOPENSSL_SMALL_FOOTPRINT [see C module for
#	details] and optimized for Pentium was observed to perform
#	*better* on Pentium 100 than unrolled non-MMX assembler
#	loop... So we just say that I don't know if maintaining
#	non-MMX implementation would actually pay off, but till
#	opposite is proved "unlikely" is assumed.

$0 =~ m/(.*[\/\\])[^\/\\]+$/; $dir=$1;
push(@INC,"${dir}","${dir}../../perlasm");
require "x86asm.pl";

&asm_init($ARGV[0],"wp-mmx.pl");

sub L()  { &data_byte(@_); }
sub LL()
{	if	($SCALE==2)	{ &data_byte(@_); &data_byte(@_); }
	elsif	($SCALE==8)	{ for ($i=0;$i<8;$i++) {
					&data_byte(@_);
					unshift(@_,pop(@_));
				  }
				}
	else			{ die "unvalid SCALE value"; }
}

sub scale()
{	if	($SCALE==2)	{ &lea(@_[0],&DWP(0,@_[1],@_[1])); }
	elsif	($SCALE==8)	{ &lea(@_[0],&DWP(0,"",@_[1],8));  }
	else			{ die "unvalid SCALE value";       }
}

sub row()
{	if	($SCALE==2)	{ ((8-shift)&7); }
	elsif	($SCALE==8)	{ (8*shift);     }
	else			{ die "unvalid SCALE value"; }
}

$tbl="ebp";
@mm=("mm0","mm1","mm2","mm3","mm4","mm5","mm6","mm7");

&function_begin_B("whirlpool_block_mmx");
	&push	("ebp");
	&push	("ebx");
	&push	("esi");
	&push	("edi");

	&mov	("esi",&wparam(0));		# hash value
	&mov	("edi",&wparam(1));		# input data stream
	&mov	("ebp",&wparam(2));		# number of chunks in input

	&mov	("eax","esp");			# copy stack pointer
	&sub	("esp",128+20);			# allocate frame
	&and	("esp",-64);			# align for cache-line

	&lea	("ebx",&DWP(128,"esp"));
	&mov	(&DWP(0,"ebx"),"esi");		# save parameter block
	&mov	(&DWP(4,"ebx"),"edi");
	&mov	(&DWP(8,"ebx"),"ebp");
	&mov	(&DWP(16,"ebx"),"eax");		# saved stack pointer

	&call	(&label("pic_point"));
&set_label("pic_point");
	&blindpop($tbl);
	&lea	($tbl,&DWP(&label("table")."-".&label("pic_point"),$tbl));

	&xor	("ecx","ecx");
	&xor	("edx","edx");

	for($i=0;$i<8;$i++) { &movq(@mm[$i],&QWP($i*8,"esi")); }    # L=H
&set_label("outerloop");
	for($i=0;$i<8;$i++) { &movq(&QWP($i*8,"esp"),@mm[$i]); }    # K=L
	for($i=0;$i<8;$i++) { &pxor(@mm[$i],&QWP($i*8,"edi")); }    # L^=inp
	for($i=0;$i<8;$i++) { &movq(&QWP(64+$i*8,"esp"),@mm[$i]); } # S=L

	&xor	("esi","esi");
	&mov	(&DWP(12,"ebx"),"esi");		# zero round counter

&set_label("round",16);
	&movq	(@mm[0],&QWP(2048*$SCALE,$tbl,"esi",8));	# rc[r]
	&mov	("eax",&DWP(0,"esp"));
	&mov	("ebx",&DWP(4,"esp"));
	&movz	("ecx",&LB("eax"));
	&movz	("edx",&HB("eax"));
for($i=0;$i<8;$i++) {
    my $func = ($i==0)? \&movq : \&pxor;
	&shr	("eax",16);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("eax"));
	&scale	("edi","edx");
	&movz	("edx",&HB("eax"));
	&pxor	(@mm[0],&QWP(&row(0),$tbl,"esi",8));
	&$func	(@mm[1],&QWP(&row(1),$tbl,"edi",8));
	&mov	("eax",&DWP(($i+1)*8,"esp"));
	&scale	("esi","ecx");
	&movz	("ecx",&LB("ebx"));
	&scale	("edi","edx");
	&movz	("edx",&HB("ebx"));
	&$func	(@mm[2],&QWP(&row(2),$tbl,"esi",8));
	&$func	(@mm[3],&QWP(&row(3),$tbl,"edi",8));
	&shr	("ebx",16);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("ebx"));
	&scale	("edi","edx");
	&movz	("edx",&HB("ebx"));
	&$func	(@mm[4],&QWP(&row(4),$tbl,"esi",8));
	&$func	(@mm[5],&QWP(&row(5),$tbl,"edi",8));
	&mov	("ebx",&DWP(($i+1)*8+4,"esp"));
	&scale	("esi","ecx");
	&movz	("ecx",&LB("eax"));
	&scale	("edi","edx");
	&movz	("edx",&HB("eax"));
	&$func	(@mm[6],&QWP(&row(6),$tbl,"esi",8));
	&$func	(@mm[7],&QWP(&row(7),$tbl,"edi",8));
    push(@mm,shift(@mm));
}

	for($i=0;$i<8;$i++) { &movq(&QWP($i*8,"esp"),@mm[$i]); }    # K=L

for($i=0;$i<8;$i++) {
	&shr	("eax",16);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("eax"));
	&scale	("edi","edx");
	&movz	("edx",&HB("eax"));
	&pxor	(@mm[0],&QWP(&row(0),$tbl,"esi",8));
	&pxor	(@mm[1],&QWP(&row(1),$tbl,"edi",8));
	&mov	("eax",&DWP(64+($i+1)*8,"esp"))		if ($i<7);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("ebx"));
	&scale	("edi","edx");
	&movz	("edx",&HB("ebx"));
	&pxor	(@mm[2],&QWP(&row(2),$tbl,"esi",8));
	&pxor	(@mm[3],&QWP(&row(3),$tbl,"edi",8));
	&shr	("ebx",16);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("ebx"));
	&scale	("edi","edx");
	&movz	("edx",&HB("ebx"));
	&pxor	(@mm[4],&QWP(&row(4),$tbl,"esi",8));
	&pxor	(@mm[5],&QWP(&row(5),$tbl,"edi",8));
	&mov	("ebx",&DWP(64+($i+1)*8+4,"esp"))	if ($i<7);
	&scale	("esi","ecx");
	&movz	("ecx",&LB("eax"));
	&scale	("edi","edx");
	&movz	("edx",&HB("eax"));
	&pxor	(@mm[6],&QWP(&row(6),$tbl,"esi",8));
	&pxor	(@mm[7],&QWP(&row(7),$tbl,"edi",8));
    push(@mm,shift(@mm));
}
	&lea	("ebx",&DWP(128,"esp"));
	&mov	("esi",&DWP(12,"ebx"));		# pull round counter
	&add	("esi",1);
	&cmp	("esi",10);
	&je	(&label("roundsdone"));

	&mov	(&DWP(12,"ebx"),"esi");		# update round counter
	for($i=0;$i<8;$i++) { &movq(&QWP(64+$i*8,"esp"),@mm[$i]); } # S=L
	&jmp	(&label("round"));

&set_label("roundsdone",16);
	&mov	("esi",&DWP(0,"ebx"));		# reload argument block
	&mov	("edi",&DWP(4,"ebx"));
	&mov	("eax",&DWP(8,"ebx"));

	for($i=0;$i<8;$i++) { &pxor(@mm[$i],&QWP($i*8,"edi")); }    # L^=inp
	for($i=0;$i<8;$i++) { &pxor(@mm[$i],&QWP($i*8,"esi")); }    # L^=H
	for($i=0;$i<8;$i++) { &movq(&QWP($i*8,"esi"),@mm[$i]); }    # H=L

	&lea	("edi",&DWP(64,"edi"));		# inp+=64
	&sub	("eax",1);			# num--
	&jz	(&label("alldone"));
	&mov	(&DWP(4,"ebx"),"edi");		# update argument block
	&mov	(&DWP(8,"ebx"),"eax");
	&jmp	(&label("outerloop"));

&set_label("alldone");
	&emms	();
	&mov	("esp",&DWP(16,"ebx"));		# restore saved stack pointer
	&pop	("edi");
	&pop	("esi");
	&pop	("ebx");
	&pop	("ebp");
	&ret	();

&align(64);
&set_label("table");
	&LL(0x18,0x18,0x60,0x18,0xc0,0x78,0x30,0xd8);
	&LL(0x23,0x23,0x8c,0x23,0x05,0xaf,0x46,0x26);
	&LL(0xc6,0xc6,0x3f,0xc6,0x7e,0xf9,0x91,0xb8);
	&LL(0xe8,0xe8,0x87,0xe8,0x13,0x6f,0xcd,0xfb);
	&LL(0x87,0x87,0x26,0x87,0x4c,0xa1,0x13,0xcb);
	&LL(0xb8,0xb8,0xda,0xb8,0xa9,0x62,0x6d,0x11);
	&LL(0x01,0x01,0x04,0x01,0x08,0x05,0x02,0x09);
	&LL(0x4f,0x4f,0x21,0x4f,0x42,0x6e,0x9e,0x0d);
	&LL(0x36,0x36,0xd8,0x36,0xad,0xee,0x6c,0x9b);
	&LL(0xa6,0xa6,0xa2,0xa6,0x59,0x04,0x51,0xff);
	&LL(0xd2,0xd2,0x6f,0xd2,0xde,0xbd,0xb9,0x0c);
	&LL(0xf5,0xf5,0xf3,0xf5,0xfb,0x06,0xf7,0x0e);
	&LL(0x79,0x79,0xf9,0x79,0xef,0x80,0xf2,0x96);
	&LL(0x6f,0x6f,0xa1,0x6f,0x5f,0xce,0xde,0x30);
	&LL(0x91,0x91,0x7e,0x91,0xfc,0xef,0x3f,0x6d);
	&LL(0x52,0x52,0x55,0x52,0xaa,0x07,0xa4,0xf8);
	&LL(0x60,0x60,0x9d,0x60,0x27,0xfd,0xc0,0x47);
	&LL(0xbc,0xbc,0xca,0xbc,0x89,0x76,0x65,0x35);
	&LL(0x9b,0x9b,0x56,0x9b,0xac,0xcd,0x2b,0x37);
	&LL(0x8e,0x8e,0x02,0x8e,0x04,0x8c,0x01,0x8a);
	&LL(0xa3,0xa3,0xb6,0xa3,0x71,0x15,0x5b,0xd2);
	&LL(0x0c,0x0c,0x30,0x0c,0x60,0x3c,0x18,0x6c);
	&LL(0x7b,0x7b,0xf1,0x7b,0xff,0x8a,0xf6,0x84);
	&LL(0x35,0x35,0xd4,0x35,0xb5,0xe1,0x6a,0x80);
	&LL(0x1d,0x1d,0x74,0x1d,0xe8,0x69,0x3a,0xf5);
	&LL(0xe0,0xe0,0xa7,0xe0,0x53,0x47,0xdd,0xb3);
	&LL(0xd7,0xd7,0x7b,0xd7,0xf6,0xac,0xb3,0x21);
	&LL(0xc2,0xc2,0x2f,0xc2,0x5e,0xed,0x99,0x9c);
	&LL(0x2e,0x2e,0xb8,0x2e,0x6d,0x96,0x5c,0x43);
	&LL(0x4b,0x4b,0x31,0x4b,0x62,0x7a,0x96,0x29);
	&LL(0xfe,0xfe,0xdf,0xfe,0xa3,0x21,0xe1,0x5d);
	&LL(0x57,0x57,0x41,0x57,0x82,0x16,0xae,0xd5);
	&LL(0x15,0x15,0x54,0x15,0xa8,0x41,0x2a,0xbd);
	&LL(0x77,0x77,0xc1,0x77,0x9f,0xb6,0xee,0xe8);
	&LL(0x37,0x37,0xdc,0x37,0xa5,0xeb,0x6e,0x92);
	&LL(0xe5,0xe5,0xb3,0xe5,0x7b,0x56,0xd7,0x9e);
	&LL(0x9f,0x9f,0x46,0x9f,0x8c,0xd9,0x23,0x13);
	&LL(0xf0,0xf0,0xe7,0xf0,0xd3,0x17,0xfd,0x23);
	&LL(0x4a,0x4a,0x35,0x4a,0x6a,0x7f,0x94,0x20);
	&LL(0xda,0xda,0x4f,0xda,0x9e,0x95,0xa9,0x44);
	&LL(0x58,0x58,0x7d,0x58,0xfa,0x25,0xb0,0xa2);
	&LL(0xc9,0xc9,0x03,0xc9,0x06,0xca,0x8f,0xcf);
	&LL(0x29,0x29,0xa4,0x29,0x55,0x8d,0x52,0x7c);
	&LL(0x0a,0x0a,0x28,0x0a,0x50,0x22,0x14,0x5a);
	&LL(0xb1,0xb1,0xfe,0xb1,0xe1,0x4f,0x7f,0x50);
	&LL(0xa0,0xa0,0xba,0xa0,0x69,0x1a,0x5d,0xc9);
	&LL(0x6b,0x6b,0xb1,0x6b,0x7f,0xda,0xd6,0x14);
	&LL(0x85,0x85,0x2e,0x85,0x5c,0xab,0x17,0xd9);
	&LL(0xbd,0xbd,0xce,0xbd,0x81,0x73,0x67,0x3c);
	&LL(0x5d,0x5d,0x69,0x5d,0xd2,0x34,0xba,0x8f);
	&LL(0x10,0x10,0x40,0x10,0x80,0x50,0x20,0x90);
	&LL(0xf4,0xf4,0xf7,0xf4,0xf3,0x03,0xf5,0x07);
	&LL(0xcb,0xcb,0x0b,0xcb,0x16,0xc0,0x8b,0xdd);
	&LL(0x3e,0x3e,0xf8,0x3e,0xed,0xc6,0x7c,0xd3);
	&LL(0x05,0x05,0x14,0x05,0x28,0x11,0x0a,0x2d);
	&LL(0x67,0x67,0x81,0x67,0x1f,0xe6,0xce,0x78);
	&LL(0xe4,0xe4,0xb7,0xe4,0x73,0x53,0xd5,0x97);
	&LL(0x27,0x27,0x9c,0x27,0x25,0xbb,0x4e,0x02);
	&LL(0x41,0x41,0x19,0x41,0x32,0x58,0x82,0x73);
	&LL(0x8b,0x8b,0x16,0x8b,0x2c,0x9d,0x0b,0xa7);
	&LL(0xa7,0xa7,0xa6,0xa7,0x51,0x01,0x53,0xf6);
	&LL(0x7d,0x7d,0xe9,0x7d,0xcf,0x94,0xfa,0xb2);
	&LL(0x95,0x95,0x6e,0x95,0xdc,0xfb,0x37,0x49);
	&LL(0xd8,0xd8,0x47,0xd8,0x8e,0x9f,0xad,0x56);
	&LL(0xfb,0xfb,0xcb,0xfb,0x8b,0x30,0xeb,0x70);
	&LL(0xee,0xee,0x9f,0xee,0x23,0x71,0xc1,0xcd);
	&LL(0x7c,0x7c,0xed,0x7c,0xc7,0x91,0xf8,0xbb);
	&LL(0x66,0x66,0x85,0x66,0x17,0xe3,0xcc,0x71);
	&LL(0xdd,0xdd,0x53,0xdd,0xa6,0x8e,0xa7,0x7b);
	&LL(0x17,0x17,0x5c,0x17,0xb8,0x4b,0x2e,0xaf);
	&LL(0x47,0x47,0x01,0x47,0x02,0x46,0x8e,0x45);
	&LL(0x9e,0x9e,0x42,0x9e,0x84,0xdc,0x21,0x1a);
	&LL(0xca,0xca,0x0f,0xca,0x1e,0xc5,0x89,0xd4);
	&LL(0x2d,0x2d,0xb4,0x2d,0x75,0x99,0x5a,0x58);
	&LL(0xbf,0xbf,0xc6,0xbf,0x91,0x79,0x63,0x2e);
	&LL(0x07,0x07,0x1c,0x07,0x38,0x1b,0x0e,0x3f);
	&LL(0xad,0xad,0x8e,0xad,0x01,0x23,0x47,0xac);
	&LL(0x5a,0x5a,0x75,0x5a,0xea,0x2f,0xb4,0xb0);
	&LL(0x83,0x83,0x36,0x83,0x6c,0xb5,0x1b,0xef);
	&LL(0x33,0x33,0xcc,0x33,0x85,0xff,0x66,0xb6);
	&LL(0x63,0x63,0x91,0x63,0x3f,0xf2,0xc6,0x5c);
	&LL(0x02,0x02,0x08,0x02,0x10,0x0a,0x04,0x12);
	&LL(0xaa,0xaa,0x92,0xaa,0x39,0x38,0x49,0x93);
	&LL(0x71,0x71,0xd9,0x71,0xaf,0xa8,0xe2,0xde);
	&LL(0xc8,0xc8,0x07,0xc8,0x0e,0xcf,0x8d,0xc6);
	&LL(0x19,0x19,0x64,0x19,0xc8,0x7d,0x32,0xd1);
	&LL(0x49,0x49,0x39,0x49,0x72,0x70,0x92,0x3b);
	&LL(0xd9,0xd9,0x43,0xd9,0x86,0x9a,0xaf,0x5f);
	&LL(0xf2,0xf2,0xef,0xf2,0xc3,0x1d,0xf9,0x31);
	&LL(0xe3,0xe3,0xab,0xe3,0x4b,0x48,0xdb,0xa8);
	&LL(0x5b,0x5b,0x71,0x5b,0xe2,0x2a,0xb6,0xb9);
	&LL(0x88,0x88,0x1a,0x88,0x34,0x92,0x0d,0xbc);
	&LL(0x9a,0x9a,0x52,0x9a,0xa4,0xc8,0x29,0x3e);
	&LL(0x26,0x26,0x98,0x26,0x2d,0xbe,0x4c,0x0b);
	&LL(0x32,0x32,0xc8,0x32,0x8d,0xfa,0x64,0xbf);
	&LL(0xb0,0xb0,0xfa,0xb0,0xe9,0x4a,0x7d,0x59);
	&LL(0xe9,0xe9,0x83,0xe9,0x1b,0x6a,0xcf,0xf2);
	&LL(0x0f,0x0f,0x3c,0x0f,0x78,0x33,0x1e,0x77);
	&LL(0xd5,0xd5,0x73,0xd5,0xe6,0xa6,0xb7,0x33);
	&LL(0x80,0x80,0x3a,0x80,0x74,0xba,0x1d,0xf4);
	&LL(0xbe,0xbe,0xc2,0xbe,0x99,0x7c,0x61,0x27);
	&LL(0xcd,0xcd,0x13,0xcd,0x26,0xde,0x87,0xeb);
	&LL(0x34,0x34,0xd0,0x34,0xbd,0xe4,0x68,0x89);
	&LL(0x48,0x48,0x3d,0x48,0x7a,0x75,0x90,0x32);
	&LL(0xff,0xff,0xdb,0xff,0xab,0x24,0xe3,0x54);
	&LL(0x7a,0x7a,0xf5,0x7a,0xf7,0x8f,0xf4,0x8d);
	&LL(0x90,0x90,0x7a,0x90,0xf4,0xea,0x3d,0x64);
	&LL(0x5f,0x5f,0x61,0x5f,0xc2,0x3e,0xbe,0x9d);
	&LL(0x20,0x20,0x80,0x20,0x1d,0xa0,0x40,0x3d);
	&LL(0x68,0x68,0xbd,0x68,0x67,0xd5,0xd0,0x0f);
	&LL(0x1a,0x1a,0x68,0x1a,0xd0,0x72,0x34,0xca);
	&LL(0xae,0xae,0x82,0xae,0x19,0x2c,0x41,0xb7);
	&LL(0xb4,0xb4,0xea,0xb4,0xc9,0x5e,0x75,0x7d);
	&LL(0x54,0x54,0x4d,0x54,0x9a,0x19,0xa8,0xce);
	&LL(0x93,0x93,0x76,0x93,0xec,0xe5,0x3b,0x7f);
	&LL(0x22,0x22,0x88,0x22,0x0d,0xaa,0x44,0x2f);
	&LL(0x64,0x64,0x8d,0x64,0x07,0xe9,0xc8,0x63);
	&LL(0xf1,0xf1,0xe3,0xf1,0xdb,0x12,0xff,0x2a);
	&LL(0x73,0x73,0xd1,0x73,0xbf,0xa2,0xe6,0xcc);
	&LL(0x12,0x12,0x48,0x12,0x90,0x5a,0x24,0x82);
	&LL(0x40,0x40,0x1d,0x40,0x3a,0x5d,0x80,0x7a);
	&LL(0x08,0x08,0x20,0x08,0x40,0x28,0x10,0x48);
	&LL(0xc3,0xc3,0x2b,0xc3,0x56,0xe8,0x9b,0x95);
	&LL(0xec,0xec,0x97,0xec,0x33,0x7b,0xc5,0xdf);
	&LL(0xdb,0xdb,0x4b,0xdb,0x96,0x90,0xab,0x4d);
	&LL(0xa1,0xa1,0xbe,0xa1,0x61,0x1f,0x5f,0xc0);
	&LL(0x8d,0x8d,0x0e,0x8d,0x1c,0x83,0x07,0x91);
	&LL(0x3d,0x3d,0xf4,0x3d,0xf5,0xc9,0x7a,0xc8);
	&LL(0x97,0x97,0x66,0x97,0xcc,0xf1,0x33,0x5b);
	&LL(0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00);
	&LL(0xcf,0xcf,0x1b,0xcf,0x36,0xd4,0x83,0xf9);
	&LL(0x2b,0x2b,0xac,0x2b,0x45,0x87,0x56,0x6e);
	&LL(0x76,0x76,0xc5,0x76,0x97,0xb3,0xec,0xe1);
	&LL(0x82,0x82,0x32,0x82,0x64,0xb0,0x19,0xe6);
	&LL(0xd6,0xd6,0x7f,0xd6,0xfe,0xa9,0xb1,0x28);
	&LL(0x1b,0x1b,0x6c,0x1b,0xd8,0x77,0x36,0xc3);
	&LL(0xb5,0xb5,0xee,0xb5,0xc1,0x5b,0x77,0x74);
	&LL(0xaf,0xaf,0x86,0xaf,0x11,0x29,0x43,0xbe);
	&LL(0x6a,0x6a,0xb5,0x6a,0x77,0xdf,0xd4,0x1d);
	&LL(0x50,0x50,0x5d,0x50,0xba,0x0d,0xa0,0xea);
	&LL(0x45,0x45,0x09,0x45,0x12,0x4c,0x8a,0x57);
	&LL(0xf3,0xf3,0xeb,0xf3,0xcb,0x18,0xfb,0x38);
	&LL(0x30,0x30,0xc0,0x30,0x9d,0xf0,0x60,0xad);
	&LL(0xef,0xef,0x9b,0xef,0x2b,0x74,0xc3,0xc4);
	&LL(0x3f,0x3f,0xfc,0x3f,0xe5,0xc3,0x7e,0xda);
	&LL(0x55,0x55,0x49,0x55,0x92,0x1c,0xaa,0xc7);
	&LL(0xa2,0xa2,0xb2,0xa2,0x79,0x10,0x59,0xdb);
	&LL(0xea,0xea,0x8f,0xea,0x03,0x65,0xc9,0xe9);
	&LL(0x65,0x65,0x89,0x65,0x0f,0xec,0xca,0x6a);
	&LL(0xba,0xba,0xd2,0xba,0xb9,0x68,0x69,0x03);
	&LL(0x2f,0x2f,0xbc,0x2f,0x65,0x93,0x5e,0x4a);
	&LL(0xc0,0xc0,0x27,0xc0,0x4e,0xe7,0x9d,0x8e);
	&LL(0xde,0xde,0x5f,0xde,0xbe,0x81,0xa1,0x60);
	&LL(0x1c,0x1c,0x70,0x1c,0xe0,0x6c,0x38,0xfc);
	&LL(0xfd,0xfd,0xd3,0xfd,0xbb,0x2e,0xe7,0x46);
	&LL(0x4d,0x4d,0x29,0x4d,0x52,0x64,0x9a,0x1f);
	&LL(0x92,0x92,0x72,0x92,0xe4,0xe0,0x39,0x76);
	&LL(0x75,0x75,0xc9,0x75,0x8f,0xbc,0xea,0xfa);
	&LL(0x06,0x06,0x18,0x06,0x30,0x1e,0x0c,0x36);
	&LL(0x8a,0x8a,0x12,0x8a,0x24,0x98,0x09,0xae);
	&LL(0xb2,0xb2,0xf2,0xb2,0xf9,0x40,0x79,0x4b);
	&LL(0xe6,0xe6,0xbf,0xe6,0x63,0x59,0xd1,0x85);
	&LL(0x0e,0x0e,0x38,0x0e,0x70,0x36,0x1c,0x7e);
	&LL(0x1f,0x1f,0x7c,0x1f,0xf8,0x63,0x3e,0xe7);
	&LL(0x62,0x62,0x95,0x62,0x37,0xf7,0xc4,0x55);
	&LL(0xd4,0xd4,0x77,0xd4,0xee,0xa3,0xb5,0x3a);
	&LL(0xa8,0xa8,0x9a,0xa8,0x29,0x32,0x4d,0x81);
	&LL(0x96,0x96,0x62,0x96,0xc4,0xf4,0x31,0x52);
	&LL(0xf9,0xf9,0xc3,0xf9,0x9b,0x3a,0xef,0x62);
	&LL(0xc5,0xc5,0x33,0xc5,0x66,0xf6,0x97,0xa3);
	&LL(0x25,0x25,0x94,0x25,0x35,0xb1,0x4a,0x10);
	&LL(0x59,0x59,0x79,0x59,0xf2,0x20,0xb2,0xab);
	&LL(0x84,0x84,0x2a,0x84,0x54,0xae,0x15,0xd0);
	&LL(0x72,0x72,0xd5,0x72,0xb7,0xa7,0xe4,0xc5);
	&LL(0x39,0x39,0xe4,0x39,0xd5,0xdd,0x72,0xec);
	&LL(0x4c,0x4c,0x2d,0x4c,0x5a,0x61,0x98,0x16);
	&LL(0x5e,0x5e,0x65,0x5e,0xca,0x3b,0xbc,0x94);
	&LL(0x78,0x78,0xfd,0x78,0xe7,0x85,0xf0,0x9f);
	&LL(0x38,0x38,0xe0,0x38,0xdd,0xd8,0x70,0xe5);
	&LL(0x8c,0x8c,0x0a,0x8c,0x14,0x86,0x05,0x98);
	&LL(0xd1,0xd1,0x63,0xd1,0xc6,0xb2,0xbf,0x17);
	&LL(0xa5,0xa5,0xae,0xa5,0x41,0x0b,0x57,0xe4);
	&LL(0xe2,0xe2,0xaf,0xe2,0x43,0x4d,0xd9,0xa1);
	&LL(0x61,0x61,0x99,0x61,0x2f,0xf8,0xc2,0x4e);
	&LL(0xb3,0xb3,0xf6,0xb3,0xf1,0x45,0x7b,0x42);
	&LL(0x21,0x21,0x84,0x21,0x15,0xa5,0x42,0x34);
	&LL(0x9c,0x9c,0x4a,0x9c,0x94,0xd6,0x25,0x08);
	&LL(0x1e,0x1e,0x78,0x1e,0xf0,0x66,0x3c,0xee);
	&LL(0x43,0x43,0x11,0x43,0x22,0x52,0x86,0x61);
	&LL(0xc7,0xc7,0x3b,0xc7,0x76,0xfc,0x93,0xb1);
	&LL(0xfc,0xfc,0xd7,0xfc,0xb3,0x2b,0xe5,0x4f);
	&LL(0x04,0x04,0x10,0x04,0x20,0x14,0x08,0x24);
	&LL(0x51,0x51,0x59,0x51,0xb2,0x08,0xa2,0xe3);
	&LL(0x99,0x99,0x5e,0x99,0xbc,0xc7,0x2f,0x25);
	&LL(0x6d,0x6d,0xa9,0x6d,0x4f,0xc4,0xda,0x22);
	&LL(0x0d,0x0d,0x34,0x0d,0x68,0x39,0x1a,0x65);
	&LL(0xfa,0xfa,0xcf,0xfa,0x83,0x35,0xe9,0x79);
	&LL(0xdf,0xdf,0x5b,0xdf,0xb6,0x84,0xa3,0x69);
	&LL(0x7e,0x7e,0xe5,0x7e,0xd7,0x9b,0xfc,0xa9);
	&LL(0x24,0x24,0x90,0x24,0x3d,0xb4,0x48,0x19);
	&LL(0x3b,0x3b,0xec,0x3b,0xc5,0xd7,0x76,0xfe);
	&LL(0xab,0xab,0x96,0xab,0x31,0x3d,0x4b,0x9a);
	&LL(0xce,0xce,0x1f,0xce,0x3e,0xd1,0x81,0xf0);
	&LL(0x11,0x11,0x44,0x11,0x88,0x55,0x22,0x99);
	&LL(0x8f,0x8f,0x06,0x8f,0x0c,0x89,0x03,0x83);
	&LL(0x4e,0x4e,0x25,0x4e,0x4a,0x6b,0x9c,0x04);
	&LL(0xb7,0xb7,0xe6,0xb7,0xd1,0x51,0x73,0x66);
	&LL(0xeb,0xeb,0x8b,0xeb,0x0b,0x60,0xcb,0xe0);
	&LL(0x3c,0x3c,0xf0,0x3c,0xfd,0xcc,0x78,0xc1);
	&LL(0x81,0x81,0x3e,0x81,0x7c,0xbf,0x1f,0xfd);
	&LL(0x94,0x94,0x6a,0x94,0xd4,0xfe,0x35,0x40);
	&LL(0xf7,0xf7,0xfb,0xf7,0xeb,0x0c,0xf3,0x1c);
	&LL(0xb9,0xb9,0xde,0xb9,0xa1,0x67,0x6f,0x18);
	&LL(0x13,0x13,0x4c,0x13,0x98,0x5f,0x26,0x8b);
	&LL(0x2c,0x2c,0xb0,0x2c,0x7d,0x9c,0x58,0x51);
	&LL(0xd3,0xd3,0x6b,0xd3,0xd6,0xb8,0xbb,0x05);
	&LL(0xe7,0xe7,0xbb,0xe7,0x6b,0x5c,0xd3,0x8c);
	&LL(0x6e,0x6e,0xa5,0x6e,0x57,0xcb,0xdc,0x39);
	&LL(0xc4,0xc4,0x37,0xc4,0x6e,0xf3,0x95,0xaa);
	&LL(0x03,0x03,0x0c,0x03,0x18,0x0f,0x06,0x1b);
	&LL(0x56,0x56,0x45,0x56,0x8a,0x13,0xac,0xdc);
	&LL(0x44,0x44,0x0d,0x44,0x1a,0x49,0x88,0x5e);
	&LL(0x7f,0x7f,0xe1,0x7f,0xdf,0x9e,0xfe,0xa0);
	&LL(0xa9,0xa9,0x9e,0xa9,0x21,0x37,0x4f,0x88);
	&LL(0x2a,0x2a,0xa8,0x2a,0x4d,0x82,0x54,0x67);
	&LL(0xbb,0xbb,0xd6,0xbb,0xb1,0x6d,0x6b,0x0a);
	&LL(0xc1,0xc1,0x23,0xc1,0x46,0xe2,0x9f,0x87);
	&LL(0x53,0x53,0x51,0x53,0xa2,0x02,0xa6,0xf1);
	&LL(0xdc,0xdc,0x57,0xdc,0xae,0x8b,0xa5,0x72);
	&LL(0x0b,0x0b,0x2c,0x0b,0x58,0x27,0x16,0x53);
	&LL(0x9d,0x9d,0x4e,0x9d,0x9c,0xd3,0x27,0x01);
	&LL(0x6c,0x6c,0xad,0x6c,0x47,0xc1,0xd8,0x2b);
	&LL(0x31,0x31,0xc4,0x31,0x95,0xf5,0x62,0xa4);
	&LL(0x74,0x74,0xcd,0x74,0x87,0xb9,0xe8,0xf3);
	&LL(0xf6,0xf6,0xff,0xf6,0xe3,0x09,0xf1,0x15);
	&LL(0x46,0x46,0x05,0x46,0x0a,0x43,0x8c,0x4c);
	&LL(0xac,0xac,0x8a,0xac,0x09,0x26,0x45,0xa5);
	&LL(0x89,0x89,0x1e,0x89,0x3c,0x97,0x0f,0xb5);
	&LL(0x14,0x14,0x50,0x14,0xa0,0x44,0x28,0xb4);
	&LL(0xe1,0xe1,0xa3,0xe1,0x5b,0x42,0xdf,0xba);
	&LL(0x16,0x16,0x58,0x16,0xb0,0x4e,0x2c,0xa6);
	&LL(0x3a,0x3a,0xe8,0x3a,0xcd,0xd2,0x74,0xf7);
	&LL(0x69,0x69,0xb9,0x69,0x6f,0xd0,0xd2,0x06);
	&LL(0x09,0x09,0x24,0x09,0x48,0x2d,0x12,0x41);
	&LL(0x70,0x70,0xdd,0x70,0xa7,0xad,0xe0,0xd7);
	&LL(0xb6,0xb6,0xe2,0xb6,0xd9,0x54,0x71,0x6f);
	&LL(0xd0,0xd0,0x67,0xd0,0xce,0xb7,0xbd,0x1e);
	&LL(0xed,0xed,0x93,0xed,0x3b,0x7e,0xc7,0xd6);
	&LL(0xcc,0xcc,0x17,0xcc,0x2e,0xdb,0x85,0xe2);
	&LL(0x42,0x42,0x15,0x42,0x2a,0x57,0x84,0x68);
	&LL(0x98,0x98,0x5a,0x98,0xb4,0xc2,0x2d,0x2c);
	&LL(0xa4,0xa4,0xaa,0xa4,0x49,0x0e,0x55,0xed);
	&LL(0x28,0x28,0xa0,0x28,0x5d,0x88,0x50,0x75);
	&LL(0x5c,0x5c,0x6d,0x5c,0xda,0x31,0xb8,0x86);
	&LL(0xf8,0xf8,0xc7,0xf8,0x93,0x3f,0xed,0x6b);
	&LL(0x86,0x86,0x22,0x86,0x44,0xa4,0x11,0xc2);

	&L(0x18,0x23,0xc6,0xe8,0x87,0xb8,0x01,0x4f);	# rc[ROUNDS]
	&L(0x36,0xa6,0xd2,0xf5,0x79,0x6f,0x91,0x52);
	&L(0x60,0xbc,0x9b,0x8e,0xa3,0x0c,0x7b,0x35);
	&L(0x1d,0xe0,0xd7,0xc2,0x2e,0x4b,0xfe,0x57);
	&L(0x15,0x77,0x37,0xe5,0x9f,0xf0,0x4a,0xda);
	&L(0x58,0xc9,0x29,0x0a,0xb1,0xa0,0x6b,0x85);
	&L(0xbd,0x5d,0x10,0xf4,0xcb,0x3e,0x05,0x67);
	&L(0xe4,0x27,0x41,0x8b,0xa7,0x7d,0x95,0xd8);
	&L(0xfb,0xee,0x7c,0x66,0xdd,0x17,0x47,0x9e);
	&L(0xca,0x2d,0xbf,0x07,0xad,0x5a,0x83,0x33);

&function_end_B("whirlpool_block_mmx");
&asm_finish(); 
