<template>
  <div class="new-category">
    <h1 class="page-title">新概念课程</h1>
    <div class="video-container">
      <video
        ref="videoPlayer"
        controls
        class="hls-player"
        playsinline
        webkit-playsinline
        x5-playsinline
        disablePictureInPicture
        controlsList="nodownload noplaybackrate"
      >
        <source :src="videoUrl" type="application/x-mpegURL">
        您的浏览器不支持视频播放
      </video>
    </div>
  </div>
</template>

<script>
import Hls from 'hls.js'

export default {
  name: 'NewCategoryIndex',
  data() {
    return {
      videoUrl: 'https://okeng.top/file/m3u8/out2/v1.m3u8',
      hls: null
    }
  },
  mounted() {
    this.initVideoPlayer()
  },
  beforeDestroy() {
    if (this.hls) {
      this.hls.destroy()
    }
  },
  methods: {
    initVideoPlayer() {
      const video = this.$refs.videoPlayer
      if (Hls.isSupported()) {
        this.hls = new Hls({
          autoStartLoad: true,
          capLevelToPlayerSize: true
        })
        this.hls.attachMedia(video)
        this.hls.on(Hls.Events.MEDIA_ATTACHED, () => {
          this.hls.loadSource(this.videoUrl)
        })
      } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        video.src = this.videoUrl
      }
    }
  }
}
</script>

<style scoped>
.page-title {
  text-align: center;
  margin-bottom: 30px;
  color: #2c3e50;
}

.video-container {
  max-width: 1200px;
  margin: 0 auto;
  background: #000;
  border-radius: 12px;
  overflow: hidden;
  position: relative;
  padding-top: 56.25%; /* 16:9 比例 */
}

.hls-player {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

@media (max-width: 768px) {
  .video-container {
    margin: 0 15px;
    border-radius: 8px;
  }
  .hls-player::-webkit-media-controls {
    display: none !important;
  }
}
</style>

