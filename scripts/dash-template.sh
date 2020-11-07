#!/bin/sh

base_test()
{

test_begin $1
if [ $test_skip  = 1 ] ; then
return
fi

do_test "$MP4BOX -add $EXTERNAL_MEDIA_DIR/counter/counter_30s_I25_baseline_1280x720_512kbps.264 -new $TEMP_DIR/file.mp4" "dash-input-preparation"

if [ $5 = 1 ] ; then
do_test "$MP4BOX -dash 1000 -out $TEMP_DIR/file.mpd $2 $TEMP_DIR/file.mp4:id=v1 $TEMP_DIR/file.mp4:id=v2" "$1-dash"
else
do_test "$MP4BOX -dash 1000 -out $TEMP_DIR/file.mpd $TEMP_DIR/file.mp4$2" "$1-dash"
fi


do_hash_test $TEMP_DIR/file.mpd "$1-hash-mpd"

do_hash_test $TEMP_DIR/$3 "$1-hash-init"

do_hash_test $TEMP_DIR/$4 "$1-hash-seg"

myinspect=$TEMP_DIR/inspect.txt
do_test "$GPAC -i $TEMP_DIR/file.mpd --algo=none inspect:allp:deep:interleave=false:log=$myinspect"
do_hash_test $myinspect "inspect"


test_end

}

base_test "dash-template-bandwidth-time" ":bandwidth=600000 -profile live -segment-name test-\$Bandwidth\$-\$Time%05d\$\$Init=is\$" "test-600000-is.mp4" "test-600000-01000.m4s" 0

base_test "dash-template-repid-number" ":id=myrep -profile live -segment-name test-\$RepresentationID\$-\$Number%d\$" "test-myrep-.mp4" "test-myrep-10.m4s" 0

base_test "dash-template-baseurl-global-path" ":id=myrep -base-url some_dir/ -profile live -segment-name \$Path=some_dir/\$test-\$RepresentationID\$-\$Number%d\$" "some_dir/test-myrep-.mp4" "some_dir/test-myrep-10.m4s" 0

base_test "dash-template-baseurl-rep-path" ":id=myrep:baseURL=some_dir/ -profile live -segment-name \$Path=some_dir/\$test-\$RepresentationID\$-\$Number%d\$" "some_dir/test-myrep-.mp4" "some_dir/test-myrep-10.m4s" 0


base_test "dash-template-repid-dir-nbs" " -bs-switching no -profile live -segment-name \$RepresentationID\$/\$Number%d\$\$Init=i\$" "v2/i.mp4" "v2/10.m4s" 1
