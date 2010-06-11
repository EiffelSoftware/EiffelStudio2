/**
 * This file has no copyright assigned and is placed in the Public Domain.
 * This file is part of the w64 mingw-runtime package.
 * No warranty is given; refer to the file DISCLAIMER.PD within this package.
 */
#define MCI_MCIAVI_PLAY_WINDOW 0x01000000L
#define MCI_MCIAVI_PLAY_FULLSCREEN 0x02000000L
#define MCI_MCIAVI_PLAY_FULLBY2 0x04000000L

#define MCI_AVI_STATUS_FRAMES_SKIPPED 0x8001L
#define MCI_AVI_STATUS_LAST_PLAY_SPEED 0x8002L
#define MCI_AVI_STATUS_AUDIO_BREAKS 0x8003L

#define MCI_AVI_SETVIDEO_DRAW_PROCEDURE 0x8000L
#define MCI_AVI_SETVIDEO_PALETTE_COLOR 0x8100L
#define MCI_AVI_SETVIDEO_PALETTE_HALFTONE 0x0000FFFFL

#define MCIERR_AVI_OLDAVIFORMAT (MCIERR_CUSTOM_DRIVER_BASE + 100)
#define MCIERR_AVI_NOTINTERLEAVED (MCIERR_CUSTOM_DRIVER_BASE + 101)
#define MCIERR_AVI_NODISPDIB (MCIERR_CUSTOM_DRIVER_BASE + 102)
#define MCIERR_AVI_CANTPLAYFULLSCREEN (MCIERR_CUSTOM_DRIVER_BASE + 103)
#define MCIERR_AVI_TOOBIGFORVGA (MCIERR_CUSTOM_DRIVER_BASE + 104)
#define MCIERR_AVI_NOCOMPRESSOR (MCIERR_CUSTOM_DRIVER_BASE + 105)
#define MCIERR_AVI_DISPLAYERROR (MCIERR_CUSTOM_DRIVER_BASE + 106)
#define MCIERR_AVI_AUDIOERROR (MCIERR_CUSTOM_DRIVER_BASE + 107)
#define MCIERR_AVI_BADPALETTE (MCIERR_CUSTOM_DRIVER_BASE + 108)
