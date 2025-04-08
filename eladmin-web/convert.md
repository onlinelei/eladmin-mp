-- 极致压缩版本，同时支持 1080p、720p、480p 三种分辨率，同时支持 AAC 音频编码。
ffmpeg -i "L1-U2-1.mp4" \
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
    -force_key_frames "expr:gte(t,n_forced*10)" \
    -preset slow -tune stillimage -r 20 -g 200 -keyint_min 200 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "L1-U2-1/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "L1-U2-1/%v/stream.m3u8"

-- 添加水印，同时支持 1080p、720p、480p 三种分辨率，同时支持 AAC 音频编码。
ffmpeg -i "Unit1-ar,ir,ur,er,or.mp4" -i "/Users/ray/.ffmpeg/mark/okeng.top.png" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1][1:v]overlay=x=60:y=main_h-overlay_h-10[v1w]; [v1w]scale=1920:1080[v1out]; \
     [v2][1:v]overlay=x=60:y=main_h-overlay_h-10[v2w]; [v2w]scale=1280:720[v2out]; \
     [v3][1:v]overlay=x=60:y=main_h-overlay_h-10[v3w]; [v3w]scale=854:480[v3out]" \
    -map "[v1out]" -map 0:a -crf:v:0 24 -c:a:0 aac -b:a:0 96k \
    -map "[v2out]" -map 0:a -crf:v:1 26 -c:a:1 aac -b:a:1 96k \
    -map "[v3out]" -map 0:a -crf:v:2 28 -c:a:2 aac -b:a:2 96k \
    -var_stream_map "v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p" \
    -f hls \
    -hls_list_size 0 \
    -hls_segment_type mpegts \
    -force_key_frames "expr:gte(t,n_forced*5)" \
    -preset veryslow -tune stillimage -r 15 -g 75 -keyint_min 75 \
    -x264-params "ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1" \
    -hls_segment_filename "Unit1-ar,ir,ur,er,or/%v/stream_%03d.ts" \
    -master_pl_name "master.m3u8" \
    "Unit1-ar,ir,ur,er,or/%v/stream.m3u8"

-- 添加多个水印，同时支持 1080p、720p、480p 三种分辨率，同时支持 AAC 音频编码。
ffmpeg -i "L1-U2-1.mp4" -i "/Users/ray/.ffmpeg/mark/oup-logo.png" -i "/Users/ray/.ffmpeg/mark/parents.png" \
    -filter_complex \
    "[0:v]split=3[v1][v2][v3]; \
     [v1][1:v]overlay=x=10:y=main_h-overlay_h-10[v1_first_wm]; [v1_first_wm][2:v]overlay=x=main_w-overlay_w-10:y=main_h-overlay_h-10[v1w]; [v1w]scale=1920:1080[v1out]; \
     [v2][1:v]overlay=x=10:y=main_h-overlay_h-10[v2_first_wm]; [v2_first_wm][2:v]overlay=x=main_w-overlay_w-10:y=main_h-overlay_h-10[v2w]; [v2w]scale=1280:720[v2out]; \
     [v3][1:v]overlay=x=10:y=main_h-overlay_h-10[v3_first_wm]; [v3_first_wm][2:v]overlay=x=main_w-overlay_w-10:y=main_h-overlay_h-10[v3w]; [v3w]scale=854:480[v3out]" \
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