<template>
  <div class="new-category">
    <h1 class="page-title">英语作文
      <span class="title-decoration" />
    </h1>
    <div class="content-container">
      <!-- 视频播放区域 -->
      <div class="video-wrapper">
        <div class="video-container">
          <div v-if="isLoading" class="loading-overlay">
            <div class="loading-spinner" />
            <div class="loading-text">加载中...</div>
          </div>
          <video
            ref="videoPlayer"
            controls
            class="video-player"
            preload="metadata"
            disablePictureInPicture
            controlsList="nodownload noplaybackrate"
            @waiting="onVideoWaiting"
            @playing="onVideoPlaying"
            @loadedmetadata="adjustVideoHeight"
          >
            <source :src="currentVideoUrl" type="application/x-mpegURL">
            您的浏览器不支持 video 标签。
          </video>
        </div>
      </div>

      <!-- 分级播放列表 -->
      <div class="playlist-container">
        <h2 class="playlist-title">
          <i class="el-icon-menu" />
          课程目录
        </h2>
        <div class="playlist-scroll">
          <ul class="playlist">
            <li
              v-for="(category, index) in categorizedPlaylist"
              :key="'cat-'+index"
              class="category-item"
              :class="{ expanded: category.expanded }"
            >
              <div class="category-header" @click="toggleCategory(category)">
                <i v-if="category.expanded" class="el-icon-folder-opened" />
                <i v-else class="el-icon-folder" />
                {{ category.name }}
                <i class="el-icon-arrow-right arrow-icon" />
              </div>
              <transition name="slide">
                <ul v-show="category.expanded" class="sub-list">
                  <li
                    v-for="(video, vIndex) in category.videos"
                    :key="'vid-'+vIndex"
                    :class="{ 'active': currentVideoUrl === video.url }"
                    @click.stop="playVideo(video)"
                  >
                    <i class="el-icon-video-play" />
                    <span class="video-title">{{ video.title }}</span>
                  </li>
                </ul>
              </transition>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// 引入hls.js
import Hls from 'hls.js'

export default {
  name: 'NewCategoryIndex',
  data() {
    return {
      currentVideoUrl: '',
      isLoading: false,
      categorizedPlaylist: [
        {
          name: '通用技巧',
          expanded: true,
          videos: [
            { title: '通用技巧-上集', url: 'https://okeng.top/file/essay/Unit1-GeneralTips-1/master.m3u8' },
            { title: '通用技巧-下集', url: 'https://okeng.top/file/essay/Unit1-GeneralTips-2/master.m3u8' }
          ]
        },
        {
          name: '扩展技巧',
          expanded: false,
          videos: [
            { title: '扩写句子-上集', url: 'https://okeng.top/file/essay/Unit2-ExpandSentences-1/master.m3u8' },
            { title: '扩写句子-下集', url: 'https://okeng.top/file/essay/Unit2-ExpandSentences-2/master.m3u8' },
            { title: '扩写要点-上集', url: 'https://okeng.top/file/essay/Unit3-ExpansionPoint-1/master.m3u8' },
            { title: '扩写要点-下集', url: 'https://okeng.top/file/essay/Unit3-ExpansionPoint-2/master.m3u8' },
            { title: '巧用词汇-上集', url: 'https://okeng.top/file/essay/Unit4-AdvancedVocabulary-1/master.m3u8' },
            { title: '巧用词汇-下集', url: 'https://okeng.top/file/essay/Unit4-AdvancedVocabulary-2/master.m3u8' },
            { title: '巧用连词-上集', url: 'https://okeng.top/file/essay/Unit5-Conjunction-1/master.m3u8' },
            { title: '巧用连词-下集', url: 'https://okeng.top/file/essay/Unit5-Conjunction-2/master.m3u8' },
            { title: '高级句型-上集', url: 'https://okeng.top/file/essay/Unit6-SentencePattern-1/master.m3u8' },
            { title: '高级句型-下集', url: 'https://okeng.top/file/essay/Unit6-SentencePattern-2/master.m3u8' },
            { title: '加分谚语-上集', url: 'https://okeng.top/file/essay/Unit7-Proverb-1/master.m3u8' },
            { title: '加分谚语-下集', url: 'https://okeng.top/file/essay/Unit7-Proverb-2/master.m3u8' },
            { title: '书写技巧', url: 'https://okeng.top/file/essay/Unit8-Write/master.m3u8' }
          ]
        },
        {
          name: '常见作文演练',
          expanded: false,
          videos: [
            { title: '建议类作文-上集', url: 'https://okeng.top/file/essay/Unit9-SuggestedEssay-1/master.m3u8' },
            { title: '建议类作文-下集', url: 'https://okeng.top/file/essay/Unit9-SuggestedEssay-2/master.m3u8' },
            { title: '假期类作文', url: 'https://okeng.top/file/essay/Unit10-HolidayEssay/master.m3u8' },
            { title: '记叙类作文-上集', url: 'https://okeng.top/file/essay/Unit11-NarrativeWriting-1/master.m3u8' },
            { title: '记叙类作文-下集', url: 'https://okeng.top/file/essay/Unit11-NarrativeWriting-2/master.m3u8' },
            { title: '热点话题类作文', url: 'https://okeng.top/file/essay/Unit12-HotTopicEssay/master.m3u8' }
          ]
        }
      ],
      videoAspectRatio: null,
      hls: null // 新增hls实例
    }
  },
  mounted() {
    // 不再初始化视频

    // 添加窗口大小变化监听器
    window.addEventListener('resize', this.adjustVideoHeight)
    // 添加触摸事件监听
    const videoContainer = document.querySelector('.video-container')
    if (videoContainer) {
      videoContainer.addEventListener('touchmove', this.preventTouchZoom, { passive: false })
      videoContainer.addEventListener('gesturestart', this.preventTouchZoom)
    }

    // --- 可选: 如果视频可能在挂载后立即加载完成 ---
    // this.$nextTick(() => {
    //   if (this.$refs.videoPlayer && this.$refs.videoPlayer.readyState >= 1) { // HAVE_METADATA or higher
    //     this.adjustVideoHeight();
    //   }
    // });
    // --- 可选 End ---
  },
  beforeDestroy() {
    // 移除窗口大小变化监听器，防止内存泄漏
    window.removeEventListener('resize', this.adjustVideoHeight)
    // 移除事件监听
    const videoContainer = document.querySelector('.video-container')
    if (videoContainer) {
      videoContainer.removeEventListener('touchmove', this.preventTouchZoom)
      videoContainer.removeEventListener('gesturestart', this.preventTouchZoom)
    }
  },
  methods: {
    toggleCategory(category) {
      category.expanded = !category.expanded
    },
    playVideo(video) {
      if (this.currentVideoUrl !== video.url) {
        this.currentVideoUrl = video.url
        this.videoAspectRatio = null
        this.$nextTick(() => {
          const player = this.$refs.videoPlayer
          if (player) {
            // 先停止当前播放
            player.pause()
            player.removeAttribute('src')
            player.load()
            // 初始化HLS播放器
            this.initHlsPlayer()
            // 更新播放状态
            this.isLoading = true
            // 增强事件拦截
            player.addEventListener('contextmenu', this.preventDownload)
            player.addEventListener('dragstart', this.preventDownload)
            player.addEventListener('selectstart', this.preventDownload)
            player.addEventListener('touchstart', this.preventDownload)
          }
        })
      }
      // 更新播放列表选中状态
      this.categorizedPlaylist.forEach(category => {
        category.videos.forEach(item => {
          item.active = false
        })
      })
      video.active = true
    },
    // 新增触摸事件处理
    preventTouchZoom(e) {
      e.preventDefault()
      e.stopPropagation()
    },
    onVideoWaiting() {
      this.isLoading = true
    },
    onVideoPlaying() {
      this.isLoading = false
    },
    adjustVideoHeight() {
      const video = this.$refs.videoPlayer
      if (!video) return // 确保 video 元素存在
      // 尝试在元数据加载后获取宽高比
      if (video.videoWidth && video.videoHeight) {
        this.videoAspectRatio = video.videoHeight / video.videoWidth
      }
      // 如果已经获取了宽高比，则根据当前宽度调整高度
      if (this.videoAspectRatio) {
        const currentWidth = video.offsetWidth // 获取播放器元素当前的实际宽度
        if (currentWidth > 0) {
          const newHeight = currentWidth * this.videoAspectRatio
          video.style.height = `${newHeight}px`
        } else {
          // 如果当前宽度为0 (可能在元素隐藏时发生)，可以移除高度设置或设置为auto
          video.style.height = 'auto'
        }
      } else {
        // 如果没有宽高比信息（例如视频加载失败），则回退到默认行为
        video.style.height = 'auto'
      }
    },
    // 新增HLS播放器初始化方法
    initHlsPlayer() {
      const video = this.$refs.videoPlayer
      if (this.hls) {
        this.hls.destroy()
      }
      if (Hls.isSupported()) {
        this.hls = new Hls({
          autoStartLoad: true,
          capLevelToPlayerSize: true,
          enableWorker: true,
          lowLatencyMode: true,
          maxMaxBufferLength: 240, // 新增：限制最大缓冲长度秒数
          maxBufferSize: 60000000, // 新增：最大缓冲区大小60MB
          maxBufferLength: 60, // 新增：最大缓冲长度秒数
          xhrSetup: (xhr, url) => {
            xhr.withCredentials = true
          }
        })
        this.hls.attachMedia(video)
        this.hls.loadSource(this.currentVideoUrl)
        this.hls.on(Hls.Events.MANIFEST_PARSED, (event, data) => {
          // 获取可用清晰度
          this.availableQualities = data.levels.map(level => ({
            id: level.id,
            name: `${level.height}P`,
            width: level.width,
            height: level.height,
            bitrate: level.bitrate
          }))
          // 设置默认清晰度
          this.currentQuality = this.hls.currentLevel
          video.play()
        })
        this.hls.on(Hls.Events.ERROR, (event, data) => {
          if (data.fatal) {
            switch (data.type) {
              case Hls.ErrorTypes.NETWORK_ERROR:
                this.hls.startLoad()
                break
              case Hls.ErrorTypes.MEDIA_ERROR:
                this.hls.recoverMediaError()
                break
              default:
                this.hls.destroy()
                break
            }
          }
        })
      } else if (video.canPlayType('application/vnd.apple.mpegurl')) {
        // Safari原生支持
        video.src = this.currentVideoUrl
        video.addEventListener('loadedmetadata', () => {
          video.play()
        })
      } else {
        console.error('当前浏览器不支持HLS播放')
      }
    },
    beforeDestroy() {
      // 销毁hls实例
      if (this.hls) {
        this.hls.destroy()
      }
    }
  },
  changeQuality(levelId) {
    if (this.hls) {
      this.hls.currentLevel = levelId
      this.currentQuality = levelId
      this.showQualitySelector = false
    }
  },
  toggleQualitySelector() {
    this.showQualitySelector = !this.showQualitySelector
  }
}
</script>

<style scoped>
/* 页面容器样式 */
.new-category {
  padding: 30px 40px;
  background: #f5f7fa;
  min-height: 100vh;
}

/* 页面标题样式 */
.page-title {
  font-size: 28px;
  color: #2c3e50;
  margin-bottom: 30px;
  position: relative;
  text-align: center;
  padding-bottom: 15px;
}

/* 标题装饰线样式 */
.title-decoration {
  display: block;
  width: 60px;
  height: 3px;
  background: linear-gradient(90deg, #409EFF, transparent);
  margin: 10px auto 0;
}

/* 内容容器样式 */
.content-container {
  display: flex;
  gap: 30px;
  max-width: 1400px;
  margin: 0 auto;
  flex-wrap: nowrap; /* 防止换行 */
}

/* 视频区域容器样式 */
.video-wrapper {
  flex: 3;
  min-width: 0;
  overflow: hidden;
}

/* 视频容器样式 */
.video-container {
  background: #000;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 8px 30px rgba(0,0,0,0.15);
  position: relative;
  padding-top: 56.25%; /* 16:9 比例 */
}

/* 视频播放器样式 */
.video-player {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  object-fit: contain;
}

/* 播放列表容器样式 */
.playlist-container {
  flex: 1;
  min-width: 350px;
  max-width: 370px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.08);
  padding: 20px;
  display: flex;
  flex-direction: column;
}

/* 播放列表滚动区域样式 */
.playlist-scroll {
  flex: 1;
  overflow-y: auto;
  padding-right: 10px;
}

/* 播放列表标题样式 */
.playlist-title {
  font-size: 12px; /* 原18px缩小一半 */
  color: #303133;
  margin-bottom: 20px;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f2f5;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 分类标题样式 */
.category-header {
  padding: 7px 8px;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 5px;
  transition: all 0.3s;
  background: #f8f9fa;
  border-radius: 8px;
  font-size: 12px;
  margin-left: 0; /* 新增：移除默认左边距 */
}

/* 子列表样式 */
.sub-list {
  padding-left: 10px; /* 原20px改为10px */
  margin-left: 0; /* 新增：移除默认左边距 */
  border-left: 1px solid #e0e3e7; /* 新增：添加左边框线 */
}

/* 子列表项样式 */
.sub-list li {
  padding: 6px 8px;
  margin: 2px 0 2px 10px; /* 调整左边距 */
  font-size: 11px;
  position: relative;
}

/* 子列表项hover效果 */
.sub-list li:hover {
  background: #7bb1f0;
}

/* 选中状态的子列表项样式 */
.sub-list li.active {
  background: #409EFF; /* 更深的背景色 */
  color: #fff; /* 白色文字 */
  font-weight: 500;
}

/* 视频标题样式 */
.video-title {
  flex: 1;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

/* 加载遮罩样式 */
.loading-overlay {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.7);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  z-index: 2;
}

/* 加载动画样式 */
.loading-spinner {
  width: 40px;
  height: 40px;
  border: 4px solid #f3f3f3;
  border-top: 4px solid #409EFF;
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

/* 加载文字样式 */
.loading-text {
  color: white;
  margin-top: 10px;
  font-size: 16px;
}

/* 旋转动画定义 */
@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

/* 展开收起动画 */
.slide-enter-active, .slide-leave-active {
  transition: all 0.3s ease;
}
.slide-enter, .slide-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

/* 响应式设计 */
@media (max-width: 1200px) {
  .content-container {
    flex-direction: row; /* 保持水平排列 */
  }

  .video-container {
    padding-top: 56.25%; /* 保持16:9比例 */
  }

  .playlist-container {
    width: auto;
    max-width: 350px;
  }
}

/* 响应式设计：针对小屏幕设备 */
@media (max-width: 768px) {
  .new-category {
    position: relative;
    clip-path: inset(0);
  }

  .content-container {
    flex-direction: column;
    align-items: center;
  }

  .video-wrapper {
    width: 100%;
    max-width: 100%;
    margin-bottom: 20px;
    padding: 0 10px;
    box-sizing: border-box;
    position: sticky;
    top: 0;
    z-index: 10;
    background-color: #fff;
    padding-top: 10px;
    padding-bottom: 10px;
    display: block;
  }

  .playlist-wrapper {
    width: 100%;
    max-width: 100%;
    padding: 0 10px;
    box-sizing: border-box;
    z-index: 1;
  }

  .video-player {
    width: 100%;
    height: auto;
    min-height: 200px;
    display: block;
  }

  .page-title {
    font-size: 20px;
    margin-bottom: 15px;
  }

  .playlist-item {
    padding: 8px 10px;
  }
}

/* 针对更小的屏幕，例如手机 */
@media (max-width: 480px) {
  .page-title {
    font-size: 18px;
  }
  /* 可以在这里添加更细致的调整 */
  .video-player::-webkit-media-controls-download-button,
  .video-player::-webkit-media-controls-fullscreen-button,
  .video-player::-webkit-media-controls-play-button {
    display: none !important;
  }
  .video-player::-webkit-media-controls-panel {
    padding-right: 14px;
    -webkit-justify-content: center;
  }
  /* 针对Android WebView的特殊处理 */
  .video-player::-webkit-media-controls-enclosure {
    overflow: hidden;
  }
  /* 隐藏时间信息后的下载按钮 */
  .video-player::-webkit-media-controls-current-time-display,
  .video-player::-webkit-media-controls-time-remaining-display {
    display: none;
  }
  /* 自定义控件容器 */
  .video-container::after {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    z-index: 1;
  }
}
</style>
