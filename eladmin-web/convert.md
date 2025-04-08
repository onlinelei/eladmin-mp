ffmpeg -i "L1-U2-1.mp4" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080[v1out]; \
     [v2]scale=1280:720[v2out]; \
     [v3]scale=854:480[v3out]" \
    -map "[v1out]" -map 0:a -c:v:0 libx264 -b:v:0 1000k -maxrate:v:0 1500k -bufsize:v:0 2000k -r 25 -g 250 -keyint_min 250 -preset veryslow -force_key_frames "expr:gte(t,n_forced*10)" -c:a:0 aac -b:a:0 128k \
    -map "[v2out]" -map 0:a -c:v:1 libx264 -b:v:1 600k -maxrate:v:1 900k -bufsize:v:1 1200k -r 25 -g 250 -keyint_min 250 -preset veryslow -force_key_frames "expr:gte(t,n_forced*10)" -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -c:v:2 libx264 -b:v:2 400k -maxrate:v:2 600k -bufsize:v:2 800k -r 25 -g 250 -keyint_min 250 -preset veryslow -force_key_frames "expr:gte(t,n_forced*10)" -c:a:2 aac -b:a:2 64k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_time 4 \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -hls_segment_filename "L1-U2-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L1-U2-1/%v/stream.m3u8"




ffmpeg -i "L1-U2-1.mp4" \
    -i "/Users/ray/.ffmpeg/mark/oup-logo.svg" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080[v1out]; \
     [v2]scale=1280:720[v2out]; \
     [v3]scale=854:480[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 32 -c:a:0 aac -b:a:0 96k -i:a:0 "/Users/ray/.ffmpeg/mark/oup-logo.svg" overlay=10:1 \
    -map "[v2out]" -map 0:a -crf:v:1 34 -c:a:1 aac -b:a:1 96k -i:a:1 "/Users/ray/.ffmpeg/mark/oup-logo.svg" overlay=10:1\
    -map "[v3out]" -map 0:a -crf:v:2 36 -c:a:2 aac -b:a:2 96k -i:a:2 "/Users/ray/.ffmpeg/mark/oup-logo.svg" overlay=10:1\
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 20 -g 200 -keyint_min 200 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L1-U2-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L1-U2-1/%v/stream.m3u8"


ffmpeg -i "L1-U2-1.mp4" \
    -i "/Users/ray/.ffmpeg/mark/oup-logo.png" \
    -filter_complex \
    "[1]format=rgba,colorchannelmixer=aa=0.5,scale=150:-1[wm]; \
     [0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080[v1scaled]; \
     [v1scaled][wm]overlay=W-w-10:10[v1out]; \
     [v2]scale=1280:720[v2scaled]; \
     [v2scaled][wm]overlay=W-w-10:10[v2out]; \
     [v3]scale=854:480[v3scaled]; \
     [v3scaled][wm]overlay=W-w-10:10[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 32 -c:a:0 aac -b:a:0 96k \
    -map "[v2out]" -map 0:a -crf:v:1 34 -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -crf:v:2 36 -c:a:2 aac -b:a:2 96k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 20 -g 200 -keyint_min 200 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L1-U2-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L1-U2-1/%v/stream.m3u8"

ffmpeg -i "L1-U2-1.mp4" \
    -i "/Users/ray/.ffmpeg/mark/oup-logo.png" \
    -filter_complex \
    "[1]format=rgba,colorchannelmixer=aa=0.5,scale=150:-1[wm]; \
     [0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2:color=black[v1scaled]; \
     [v1scaled][wm]overlay=W-w-10:10[v1out]; \
     [v2]scale=1280:720:force_original_aspect_ratio=decrease,pad=1280:720:(ow-iw)/2:(oh-ih)/2:color=black[v2scaled]; \
     [v2scaled][wm]overlay=W-w-10:10[v2out]; \
     [v3]scale=854:480:force_original_aspect_ratio=decrease,pad=854:480:(ow-iw)/2:(oh-ih)/2:color=black[v3scaled]; \
     [v3scaled][wm]overlay=W-w-10:10[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 32 -c:a:0 aac -b:a:0 96k \
    -map "[v2out]" -map 0:a -crf:v:1 34 -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -crf:v:2 36 -c:a:2 aac -b:a:2 96k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 20 -g 200 -keyint_min 200 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L1-U2-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L1-U2-1/%v/stream.m3u8"



ffmpeg -i "L6-U1-1-1.mp4" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080[v1out]; \
     [v2]scale=1280:720[v2out]; \
     [v3]scale=854:480[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 32 -c:a:0 aac -b:a:0 96k \
    -map "[v2out]" -map 0:a -crf:v:1 34 -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -crf:v:2 36 -c:a:2 aac -b:a:2 96k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -i "/Users/ray/.ffmpeg/mark/oup-logo.svg" overlay=10:1\
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 20 -g 200 -keyint_min 200 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L6-U1-1-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L6-U1-1-1/%v/stream.m3u8"


ffmpeg -i "L6-U1-1-1.mp4" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1]scale=1920:1080[v1out]; \
     [v2]scale=1280:720[v2out]; \
     [v3]scale=854:480[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 23 -c:a:0 aac -b:a:0 96k \
    -map "[v2out]" -map 0:a -crf:v:1 25 -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -crf:v:2 28 -c:a:2 aac -b:a:2 64k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 25 -g 250 -keyint_min 250 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L6-U1-1-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L6-U1-1-1/%v/stream.m3u8"
