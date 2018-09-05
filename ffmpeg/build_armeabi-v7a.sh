#!/bin/bash

TOOLCHAIN=/home/duncan/my_toolchains/arm
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
rm -f $(pwd)/compat/strtod.o

function build_one
{
./configure --prefix=$PREFIX \
  --disable-static\
  --disable-gpl\
  --enable-shared\
  --disable-symver\
  --disable-encoders\
  --disable-protocols\
  --enable-protocol=file\
  --enable-protocol=pipe\
  --disable-bsfs\
  --enable-bsf=aac_adtstoasc\
  --disable-indevs\
  --disable-outdevs\
  --disable-filters\
  --disable-decoders\
  --enable-filter=concat\
  --enable-filter=copy\
  --disable-doc\
  --disable-ffmpeg\
  --disable-ffplay\
  --disable-ffprobe\
  --disable-ffserver\
  --disable-asm\
  --disable-yasm\
  --disable-zlib\
  --disable-xlib\
  --disable-demuxers\
  --disable-parsers\
  --disable-debug\
  --disable-muxers\
  --enable-decoder='aac,aac_fixed,aac_latm,aic,alac,amv,webp,wmalossless,amrnb,amrwb,libvorbis,vorbis,mpegts'\
  --enable-decoder='flibopus,flac,libfdk_aac,h261,h263,h264,mp2,mp3,wmav1,wmav2,mpeg2video,mpeg4,mpegvideo,opus,rawvideo' \
  --enable-demuxer='aac,ac3,acm,aiff,amrnb,amrwb,avi,codec2,codec2raw,mkvtimestamp_v2'\
  --enable-demuxer='matroska_audio,mov,mp2,mp3,mp4,ogg,opus,mpegts,flac,flic,flv'\
  --enable-demuxer='h261,h263,h264hevc,hls'\
  --enable-demuxer='matroska,mgsts,mpegvideo,ogg,mov,mp3'\
  --enable-demuxer='mpegps,mpegts,mpegtsraw,rawvideo'\
  --enable-demuxer='pcm_alaw,pcm_f32be,pcm_f32le,pcm_f64be,pcm_f64le,pcm_mulaw,pcm_s16be,pcm_s16le'\
  --enable-demuxer='pcm_s24be,pcm_s24le,pcm_s32be,null,pcm_s32le,xmv,wav,yuv4mpegpipe,concat'\
  --enable-parser='aac,aac_latm,flac,h261,h263'\
  --enable-parser='h264,mpeg4video,mpegaudio,mpegvideo,opus,vorbis'\
  --enable-muxer='yuv4mpegpipe,wv,webm,smoothstreaming,rawvideo,opus,oga,ogg,null,mpegts,mpeg2vob'\
  --enable-muxer='mov,mp2,mp3,mp4,matroska,matroska_audio,m4v,h261,h263,h264,hls,flv,flac,f4v,ffm'\
  --enable-muxer='adts,adx,aiff,amr,asf,ass,ast,avi,dts,dash,a64,ac3'\
  --target-os=android\
  --enable-cross-compile \
  --cross-prefix=$CROSS_PREFIX \
  --extra-cflags="-Os -fpic $ADDI_CFLAGS"\
  --extra-ldflags="$ADDI_LDFLAGS"\
  --sysroot=$TOOLCHAIN/sysroot $ADDITIONAL_CONFIG_FLAG

make clean
make -j2
make install
}

CPU=armeabi-v7a
mkdir -p $(pwd)/android/$CPU
PREFIX=$(pwd)/android/$CPU 
ADDI_CFLAGS="-marm -march=armv7-a -mfloat-abi=softfp -mthumb -mfpu=vfpv3-d16 -mtune=cortex-a8"
ADDI_LDFLAGS="-marm -march=armv7-a -Wl,--fix-cortex-a8"
ADDITIONAL_CONFIG_FLAG="--arch=arm --disable-asm"
build_one
