<template>
  <div class="new-category">
    <h1 class="page-title">自然拼读</h1>
    <div class="content-container">
      <div class="video-container">
        <video ref="videoPlayer" controls>
          <source :src="currentVideoUrl" type="video/mp4">
          您的浏览器不支持 video 标签。
        </video>
      </div>
      <div class="playlist-container">
        <h2 class="playlist-title">播放列表</h2>
        <ul>
          <li v-for="(video, index) in playlist" :key="index" :class="{ 'active': currentVideoUrl === video.url }" @click="playVideo(video.url)">
            {{ video.title }}
          </li>
        </ul>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'NewCategoryIndex',
  data() {
    return {
      currentVideoUrl: '',
      playlist: [
        { title: 'Aa', url: 'http://file.okeng.top/phonicsABC/Aa.mp4' },
        { title: 'Bb', url: 'http://file.okeng.top/phonicsABC/Bb.mp4' },
        { title: 'Cc', url: 'http://file.okeng.top/phonicsABC/Cc.mp4' },
        { title: 'I can walk', url: 'http://file.okeng.top/Kids%20vocabulary%20-%20Action%20Verbs%20-%20Action%20Words%20-%20Learn%20English%20for%20kids%20-%20English%20educational%20video.mp4' }
        // 可以根据需要添加更多视频
      ]
    }
  },
  mounted() {
    // 初始化时播放第一个视频（如果需要）
    if (this.playlist.length > 0) {
      this.currentVideoUrl = this.playlist[0].url
    }
  },
  methods: {
    playVideo(url) {
      this.currentVideoUrl = url
      this.$refs.videoPlayer.load() // 重新加载视频
      this.$refs.videoPlayer.play() // 播放视频
    }
  }
}
</script>

<style scoped>
.new-category {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  box-sizing: border-box;
  width: 100%;
}

.page-title {
  font-size: 24px;
  margin-bottom: 20px;
  text-align: center;
}

.content-container {
  display: flex;
  justify-content: space-between;
  width: 100%;
  max-width: 1100px;
  box-sizing: border-box;
}

.video-container {
  flex: 2;
  margin-right: 20px;
  width: 800px; /* 固定宽度 */
  height: 450px; /* 固定高度 */
  max-width: 800px; /* 最大宽度 */
  max-height: 450px; /* 最大高度 */
  overflow: hidden; /* 防止视频溢出 */
}

.video-container video {
  width: 100%;
  height: 100%;
  background-color: #000;
  object-fit: cover; /* 保持视频比例，填充整个容器 */
}

.playlist-container {
  flex: 1;
  width: 100%;
  max-width: 300px;
}

.playlist-title {
  font-size: 18px;
  margin-bottom: 10px;
  text-align: left;
}

.playlist-container ul {
  list-style-type: none;
  padding: 0;
  border: 1px solid #ccc;
  border-radius: 5px;
  overflow: hidden;
}

.playlist-container li {
  padding: 10px;
  cursor: pointer;
  background-color: #fff;
  border-bottom: 1px solid #ccc;
}

.playlist-container li:last-child {
  border-bottom: none;
}

.playlist-container li:hover {
  background-color: #f0f0f0;
}

.playlist-container li.active {
  background-color: #e0f7fa;
  font-weight: bold;
}
</style>
