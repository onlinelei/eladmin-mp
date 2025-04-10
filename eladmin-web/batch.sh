#!/bin/bash
#source ~/.zshrc
m3() {
    ~/.ffmpeg/convert.sh "$@"
}
 

say "开始批量处理，处理中请不要关闭终端"

cd /Users/ray/Documents/卖课/录播课/第一课/m3u8
m3 -s ../压缩1000-25/*.mp4
say "第一课 处理完成"

cd /Users/ray/Documents/卖课/录播课/牛津自然拼读L1/m3u8
m3 -s ../压缩1000-25/*.mp4
say "牛津自然拼读L1 处理完成"

cd /Users/ray/Documents/卖课/录播课/牛津自然拼读L2/m3u8
m3 -s ../压缩1000-25/*.mp4
say "牛津自然拼读L2 处理完成"

cd /Users/ray/Documents/卖课/录播课/牛津自然拼读L3/m3u8
m3 -s ../压缩1000-25/*.mp4
say "牛津自然拼读L3 处理完成"

cd /Users/ray/Documents/卖课/录播课/牛津自然拼读L4/m3u8
m3 -s ../压缩1000-25/*.mp4
say "牛津自然拼读L4 处理完成"

cd /Users/ray/Documents/卖课/录播课/牛津自然拼读L5/m3u8
m3 -s ../压缩1000-25/*.mp4
say "牛津自然拼读L5 处理完成"

say "批量处理录播课加密，所有文件处理完毕！"