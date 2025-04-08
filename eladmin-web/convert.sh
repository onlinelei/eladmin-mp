#!/bin/bash

# 初始化变量
use_encryption=0

# 解析参数
while getopts ":s" opt; do
  case $opt in
    s)
      use_encryption=1
      ;;
    \?)
      echo "无效选项: -$OPTARG" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

# 检查 FFmpeg 是否安装
if ! command -v ffmpeg &> /dev/null; then
    echo "错误：FFmpeg 未安装，请先安装 FFmpeg。"
    exit 1
fi

# 检查输入文件
if [ $# -eq 0 ]; then
    echo "用法: $0 [-s] file1.mp4 file2.mp4 ..."
    echo "选项:"
    echo "  -s  启用 HLS 加密"
    exit 1
fi

# 遍历所有输入文件
for input_file in "$@"; do
    # 检查文件是否存在
    if [ ! -f "$input_file" ]; then
        echo "警告：文件 '$input_file' 不存在，跳过。"
        continue
    fi

    # 提取文件名（不带扩展名）
    filename=$(basename -- "$input_file")
    filename_noext="${filename%.*}"

    # 创建输出目录
    output_dir="$filename_noext"
    mkdir -p "$output_dir"


    echo "正在处理: $input_file → 输出目录: $output_dir/"

    say "现在开始处理 $input_file "

    # 构建 FFmpeg 命令
    ffmpeg_cmd="ffmpeg -i \"$input_file\" -i \"$HOME/.ffmpeg/mark/okeng.top.png\" \
        -filter_complex \
        \"[0:v]split=3[v1][v2][v3]; \
         [v1][1:v]overlay=x=60:y=main_h-overlay_h-10[v1w]; [v1w]scale=1920:1080[v1out]; \
         [v2][1:v]overlay=x=60:y=main_h-overlay_h-10[v2w]; [v2w]scale=1280:720[v2out]; \
         [v3][1:v]overlay=x=60:y=main_h-overlay_h-10[v3w]; [v3w]scale=854:480[v3out]\" \
        -map \"[v1out]\" -map 0:a -crf:v:0 30 -c:a:0 aac -b:a:0 96k \
        -map \"[v2out]\" -map 0:a -crf:v:1 32 -c:a:1 aac -b:a:1 96k \
        -map \"[v3out]\" -map 0:a -crf:v:2 34 -c:a:2 aac -b:a:2 96k \
        -var_stream_map \"v:0,a:0,name:1080p v:1,a:1,name:720p v:2,a:2,name:480p\" \
        -f hls \
        -hls_list_size 0 \
        -hls_segment_type mpegts \
        -force_key_frames \"expr:gte(t,n_forced*5)\" \
        -preset veryslow -tune stillimage -r 25 -g 125 -keyint_min 125 \
        -x264-params \"ref=6:bframes=0:aq-mode=1:psy-rd=0.5:no-scenecut=1\""

    # 根据需要添加加密选项
    if [ $use_encryption -eq 1 ]; then
        ffmpeg_cmd="$ffmpeg_cmd -hls_key_info_file \"$HOME/.ffmpeg/keyinfo.txt\""
    fi

    # 添加剩余参数并执行
    ffmpeg_cmd="$ffmpeg_cmd -hls_segment_filename \"$output_dir/%v/stream_%03d.ts\" \
        -master_pl_name \"master.m3u8\" \
        \"$output_dir/%v/stream.m3u8\""


    echo "开始执行:/$ffmpeg_cmd/"
    eval $ffmpeg_cmd

    echo "完成: $input_file → 输出目录: $output_dir/"

    say "处理完成 $input_file "
done

echo "所有文件处理完毕！"