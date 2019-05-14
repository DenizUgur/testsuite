

test_begin "mp4box-udta"
if [ "$test_skip" = 1 ] ; then
return
fi

mp4file="$TEMP_DIR/udtamoov.mp4"
binfile="$TEMP_DIR/dumpmoov.srt"

do_test "$MP4BOX -add $MEDIA_DIR/auxiliary_files/logo.png -udta ID=0:type=GPAC:src=$MEDIA_DIR/auxiliary_files/subtitle.srt -new $mp4file" "udta-moov"
do_hash_test $mp4file "udta-moov"

do_test "$MP4BOX -dump-udta GPAC $mp4file -out $binfile" "udta-moov-dump"
do_hash_test $binfile "udta-moov-dump"


mp4file="$TEMP_DIR/udtatrack.mp4"
binfile="$TEMP_DIR/dumptrack.bin"

do_test "$MP4BOX -add $MEDIA_DIR/auxiliary_files/logo.png -udta ID=1:type=GPAC:src=base64,dGVzdA== -new $mp4file" "udta-track"
do_hash_test $mp4file "udta-track"

do_test "$MP4BOX -dump-udta 1:GPAC $mp4file -out $binfile" "udta-track-dump"
do_hash_test $binfile "udta-track-dump"

test_end


