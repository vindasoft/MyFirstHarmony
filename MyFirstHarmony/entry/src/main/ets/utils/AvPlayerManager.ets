import { media } from '@kit.MediaKit'
import { GlobalMusic } from '../models/GlobalMusic'
import { SongItemType } from '../models/music'
import { AppStorageV2 } from '@kit.ArkUI'
import { sessionManager } from './AvSessionManager'

class AvPlayerManager {
  // 属性 + 方法

  // 播放器
  player: media.AVPlayer | null = null
  // 共享播放数据
  currentSong: GlobalMusic = AppStorageV2.connect(GlobalMusic, 'SONG_KEY', () => new GlobalMusic())!

  // 定义方法 创建播放器 + 监听播放器的状态
  async init() {
    if (!this.player) {
      this.player = await media.createAVPlayer()
    }

    // 监听播放状态
    this.player.on('stateChange', (state) => {
      if (state === 'initialized') {
        // 如果this.player是正常的播放器才能执行prepare方法
        this.player?.prepare()
      } else if (state === 'prepared') {
        // 如果this.player是正常的播放器才能执行play方法
        this.player?.play()
        this.currentSong.isPlay = true
      } else if (state === 'completed') {
        this.nextPlay(true)
      }
    })

    // 时间变化
    this.player.on('durationUpdate', (duration) => {
      this.currentSong.duration = duration
      sessionManager.setAVMetadata(this.currentSong.playList[this.currentSong.playIndex])
    })
    this.player.on('timeUpdate', (time) => {
      this.currentSong.time = time
      sessionManager.setAVPlayBackState()
    })
  }

  // 播放歌曲 -> 设置播放资源
  // singPlay(song: SongItemType) {
  //   this.player!.url = song.url
  //   this.currentSong.img = song.img
  // }

  singPlay(song: SongItemType) {
    // 申请长时任务
    sessionManager.startBackgroundTask()
    sessionManager.setAVPlayBackState()
    const inList = this.currentSong.playList.some(item => item.id === song.id)
    // 如果点击的歌曲在列表里面
    if (inList) {
      // 点击的歌曲是正在播放的歌曲，则继续播放
      if (song.url === this.currentSong.url) {
        this.player?.play()
        this.currentSong.isPlay = true
      } else { // 点击的歌曲不是正在播放的歌曲
        this.currentSong.playIndex = this.currentSong.playList.findIndex(item => item.id === song.id)
        this.changeSong()
      }
    } else { // 点击的歌曲不在播放列表里面
      // 添加到列表最前面用unshift，并且切换歌曲
      this.currentSong.playList.unshift(song)
      this.currentSong.playIndex = 0
      this.changeSong()
    }
  }

  // 切歌函数
  async changeSong() {
    await this.player?.reset()
    this.currentSong.duration = 0
    this.currentSong.time = 0
    this.currentSong.img = this.currentSong.playList[this.currentSong.playIndex].img
    this.currentSong.name = this.currentSong.playList[this.currentSong.playIndex].name
    this.currentSong.author = this.currentSong.playList[this.currentSong.playIndex].author
    this.currentSong.url = this.currentSong.playList[this.currentSong.playIndex].url
    this.player!.url = this.currentSong.url
  }

  // 跳转到指定的进度值
  seekPlay(value: number) {
    this.player?.seek(value)
  }

  // 暂停播放
  paused() {
    this.player?.pause()
    this.currentSong.isPlay = false
    sessionManager.setAVPlayBackState()
  }

  // 上一首
  prevPlay() {
    this.currentSong.playIndex--
    if (this.currentSong.playIndex < 0) {
      // 播放最后一首
      this.currentSong.playIndex = this.currentSong.playList.length - 1
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  // 下一首
  nextPlay(autoNextPlay?: boolean) {
    // 单曲循环重复播放模式：点下一首播放的还是自己
    if (this.currentSong.playMode === 'repeat' && autoNextPlay) {
      this.currentSong.playIndex = this.currentSong.playIndex
    }
    else if (this.currentSong.playMode === 'random' && autoNextPlay) { // 随机播放模式：
      // Math.random()[0,1]之间的随机小数
       this.currentSong.playIndex = Math.floor(Math.random() * this.currentSong.playList.length)
    } else {
      // 列表
      this.currentSong.playIndex++
      if (this.currentSong.playIndex >= this.currentSong.playList.length) {
        this.currentSong.playIndex = 0
      }
    }
    this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
  }

  // 删除歌曲: 封装移除方法接收移除索引splice(移除索引，个数)
  removeSong(index: number){
    //删除的是正在播放的歌曲
     if(index===this.currentSong.playIndex) {
       // 列表里面有多首歌
       if(this.currentSong.playList.length > 1){
         this.currentSong.playList.splice(index, 1)
         // 播放索引如果大于等于了长度，回第一首播放
         if(this.currentSong.playIndex >= this.currentSong.playList.length){
           this.currentSong.playIndex = 0
         }
         this.singPlay(this.currentSong.playList[this.currentSong.playIndex])
       } else{
         // 列表里面只有一首歌：直接删除，播放器重置，播放数据重置
         this.player?.reset()
         this.currentSong.reset()
       }
     } else{
       // 移除的在当前播放歌曲的前面： 播放索引减1
       if(index < this.currentSong.playIndex) {
         this.currentSong.playIndex--
       }
       // 删除函数splice参数：删除的索引，删除个数
       this.currentSong.playList.splice(index,1)
     }
  }
}

export const playerManager: AvPlayerManager = new AvPlayerManager()